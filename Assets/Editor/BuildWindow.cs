using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;

public class BuildWindow : EditorWindow {
	private Event currEvent;
	
	//Editor window
	public static BuildWindow windowInstance = null;
	public Texture2D backgroundImg;
	public Texture2D buildBtnImg;
	public Texture2D buildBtnImgOverlay;
	public Rect textureRenderRect;
	public float TextureOffsetX { get; set; }
	public float TextureOffsetY { get; set; }
	
	//Buttons
	private Vector2 currMousePos;
	private Button[] BuildBtns;
	private Rect btnSize;
	private Vector2 checkMarkPos;
	private Button buildBtn;
	private Vector2 buildBtnPosOffset;
	private BtnTypes[] btnTypesValues;
	
	//Information required for Build Process
	private string[] projectScenes;
	public string[] assetPaths;
	private string buildPath;
	private BuildTarget validDesktopBuildTarget;
	private BuildTarget[] buildTargets;
	private bool buildProcessComplete = false;
	
	//Defines what builds we want to initiate
	private byte selectionMask = 0;
	
	//Information to start the actionscript compilation process
	System.Diagnostics.Process codeTranslate;
	string outPath = "./translated/";
	string inputFiles = "";
	string executeCommand = "{0}/Cs2as.exe \"/out:{1}\" {2}";
	
	enum BtnTypes {
		FlashBuild = 1,
		IOsBuild = 1 << 1,
		AndroidBuild = 1 << 2,
		BlackBerryBuild = 1 << 3,
		DesktopBuild = 1 << 4,
		TestFlightBuild = 1 << 5,
		MAX_BTN_TYPES
	}
	
	sealed class Button {
		private Rect btnArea;
		private Rect toggleRect;
		public BtnTypes btnType { get; private set; }
		public bool IsToggleSelected { get; set; }
		public bool IsBtnClicked { get; set; }
		public bool GetIsBtnSelected() { 
			return IsToggleSelected || IsBtnClicked; 
		}
		
		public void SetBtnArea(float _left, float _top, float _width, float _height) {
			btnArea = new Rect(_left, _top, _width, _height);
		}
		
		public Rect GetBtnArea() {
			return btnArea;
		}
		
		public void SetCheckmarkPos(float _x, float _y) {
			toggleRect = new Rect(btnArea.x + _x, btnArea.y + _y, 20.0f, 20.0f);
		}
		
		public bool IsPointInArea(Vector2 _pointPos) {
			return IsPointInArea(_pointPos.x, _pointPos.y);
		}
		
		public bool IsPointInArea(float _x, float _y) {
			return _x >= btnArea.x && _x <= btnArea.x + btnArea.width && _y >= btnArea.y && _y <= btnArea.y + btnArea.height;
		}
		
		public Button() : this(new Rect(0.0f, 0.0f, 0.0f, 0.0f), new Vector2(0.0f, 0.0f), BuildWindow.BtnTypes.MAX_BTN_TYPES) {
			
		}
		
		public Button(Rect _desiredRect, Vector2 _desiredCheckPos, BtnTypes _desiredBtnType) : 
			this(_desiredRect.x, _desiredRect.y, _desiredRect.width, _desiredRect.height, _desiredCheckPos.x, _desiredCheckPos.y, _desiredBtnType) {
		}
		
		public Button(float _left, float _top, float _width, float _height, float _checkBoxPosX, float _checkBoxPosY, BtnTypes _desiredBtnType) {
			SetBtnArea(_left, _top, _width, _height);
			SetCheckmarkPos(_checkBoxPosX, _checkBoxPosY);
			IsToggleSelected = IsBtnClicked = false;
			btnType = _desiredBtnType;
		}
		
		public void OnGUIUpdate() {
			EditorGUI.Toggle(toggleRect, GetIsBtnSelected());
		}
		
	}
	
	private string BuildCallback(string[] _scenes, string _buildPath, BuildTarget _desiredTarget, BuildOptions _options) { 
		return BuildPipeline.BuildPlayer(_scenes, _buildPath, _desiredTarget, _options);
	}
	
	public void InitializeBtnObjects() {
		BuildBtns = new Button[6];
		btnTypesValues = System.Enum.GetValues(typeof(BtnTypes)) as BtnTypes[];
		for(int i = 0; i < BuildBtns.Length; ++i) {
			btnSize.x = 150.0f * (i % 3);
			if(i > 2) {
				btnSize.y = 150.0f;
			}
			BuildBtns[i] = new Button(btnSize, checkMarkPos, (BtnTypes)(btnTypesValues.GetValue(i)));
		}
		buildBtnPosOffset = new Vector2((this.backgroundImg.width * 0.5f) - (this.buildBtnImg.width * 0.5f), 
			BuildBtns[3].GetBtnArea().y + BuildBtns[3].GetBtnArea().height + 15.0f);
		buildBtn = new Button();
		buildBtn.SetBtnArea(buildBtnPosOffset.x, buildBtnPosOffset.y, buildBtnImg.width, buildBtnImg.height);
	}
	
	private void InitializeBuildTargets() {
		buildTargets = new BuildTarget[6] {
			BuildTarget.FlashPlayer,
			BuildTarget.iPhone,
			BuildTarget.Android,
			BuildTarget.BB10,
			validDesktopBuildTarget,
			BuildTarget.StandaloneWindows
		};
	}
	
	private void RenderBtns() {
		if(BuildBtns != null) {
			for(int i = 0; i < BuildBtns.Length; ++i) {
				BuildBtns[i].IsBtnClicked = (selectionMask & (byte)BuildBtns[i].btnType) != 0 ? true : false;
				BuildBtns[i].OnGUIUpdate();
			}
		}
	}
	
	private void CheckForBtnSelection(Vector2 _mousBtnPos) {
		CheckForBtnSelection(_mousBtnPos.x, _mousBtnPos.y);
	}
	
	private void CheckForBtnSelection(float _x, float _y) {
		//TODO: loop through the buttons and check if any has been "pressed"
		if(BuildBtns != null) {
			for(int i = 0; i < BuildBtns.Length; ++i) {
				if(BuildBtns[i].IsPointInArea(_x, _y)) {
					if((selectionMask & (byte)BuildBtns[i].btnType) != 0) { 
						//Clearing
						selectionMask &= (byte)(~(1 << i));
					} else {
						//Setting
						selectionMask |= (byte)BuildBtns[i].btnType;
					}
					windowInstance.Repaint();
				}
			}
			
		}
		if(buildBtn.IsPointInArea(_x, _y)) {
			PopulateSceneArray();
		}
	}
	
	private void PopulateSceneArray() {
		projectScenes = System.Array.FindAll(assetPaths, (t) => t.EndsWith(".unity", System.StringComparison.CurrentCulture));
		buildPath = EditorUtility.OpenFolderPanel("Select build folder", "", "");
		if(projectScenes != null && projectScenes.Length > 0) {
			BuildScenes();
			if(buildProcessComplete) {
				buildProcessComplete = false;
				windowInstance.Close();
			}
		} else {
			Debug.LogError("Couldn't find any scenes to build");
		}
	}
	
	private void BuildScenes() {
		for(int i = 0; i < BuildBtns.Length; ++i) {
			if((selectionMask & (byte)BuildBtns[i].btnType) != 0) {
				if(i != 0) {
					BuildCallback(projectScenes, buildPath, buildTargets[i], BuildOptions.None);
				} else {
					GenerateInputSourceFiles();
				}
			}
		}
		buildProcessComplete = true;
	}
	
	public void InitializeWindowClass() {
		assetPaths = AssetDatabase.GetAllAssetPaths();
		if(assetPaths != null) {
			if(backgroundImg == null) {
				backgroundImg = (Texture2D)AssetDatabase.LoadAssetAtPath(System.Array.Find(windowInstance.assetPaths, (t) => t.Contains("/Background.png")), typeof(Texture2D));
			}
			if(buildBtnImg == null) {
				buildBtnImg = (Texture2D)AssetDatabase.LoadAssetAtPath(System.Array.Find(windowInstance.assetPaths, (t) => t.Contains("/BuildRegular.png")), typeof(Texture2D));
			}
			if(buildBtnImgOverlay == null) {
				buildBtnImgOverlay = (Texture2D)AssetDatabase.LoadAssetAtPath(System.Array.Find(windowInstance.assetPaths, (t) => t.Contains("/BuildRollover.png")), typeof(Texture2D));
			}
		}
		validDesktopBuildTarget = BuildTarget.StandaloneOSXUniversal;
		TextureOffsetX = windowInstance.backgroundImg.width * 0.5f;
		TextureOffsetY = windowInstance.backgroundImg.height * 0.5f;
		minSize = new Vector2(windowInstance.backgroundImg.width, windowInstance.backgroundImg.height);
		maxSize = windowInstance.minSize;
		maximized = true;
		btnSize = new Rect(0.0f, 0.0f, 150.0f, 150.0f);
		checkMarkPos =  new Vector2(120.0f, 120.0f);
		
		InitializeBuildTargets();
		InitializeBtnObjects();
		
		codeTranslate = new System.Diagnostics.Process();
	}
	
	private void GenerateInputSourceFiles() {
		string executablePath = Application.dataPath + "/CS2AS";
		string removeTemplate = Application.dataPath.Remove(Application.dataPath.LastIndexOf("/Assets"));
		executablePath = executablePath.Remove(executablePath.IndexOf("/Assets"), 7);
		string inputFilesFolder = Application.dataPath + "/Scripts/CrossCompilable";
		string[] scriptFiles = System.Array.FindAll(System.IO.Directory.GetFiles(inputFilesFolder), (t) => t.Contains(".cs"));
		foreach(string scriptFile in scriptFiles) {
			inputFiles += "\".." + scriptFile.Replace(removeTemplate, "") + "\" ";
		}
		outPath = buildPath;
		System.Diagnostics.Process newProcess = new System.Diagnostics.Process();
		newProcess.StartInfo = new System.Diagnostics.ProcessStartInfo("mono", System.String.Format(executeCommand, executablePath, outPath, inputFiles));
		newProcess.StartInfo.WorkingDirectory = executablePath;
		newProcess.Start();
		newProcess.WaitForExit();
		if (newProcess.ExitCode != 0) {
			Debug.LogError("Mono error: " + newProcess.ExitCode);
		}
	}
	
	[MenuItem ("BuildManager/Build")]
	static void Init() {
		windowInstance = (BuildWindow)EditorWindow.GetWindowWithRect(typeof(BuildWindow), new Rect(120.0f, 120.0f, 240.0f, 240.0f), true, "Build Manager");
		if(windowInstance != null) {
			windowInstance.InitializeWindowClass();
		} else {
			Debug.LogError("Couldn't obtain the window");
		}
	}
	
	void OnGUI() {
		textureRenderRect = new Rect(0, 0, backgroundImg.width, backgroundImg.height);
		EditorGUI.DrawTextureTransparent(textureRenderRect, backgroundImg, ScaleMode.StretchToFill);
		currEvent = Event.current;
		RenderBtns();
		if (buildBtn != null)	
			EditorGUI.DrawTextureTransparent(buildBtn.GetBtnArea(), buildBtnImg, ScaleMode.StretchToFill);
		if(currEvent.isMouse  && currEvent.type == EventType.MouseDown) {
			currMousePos = currEvent.mousePosition;
			CheckForBtnSelection(currMousePos);
		}
	}
}
