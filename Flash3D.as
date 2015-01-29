package PV3D {	import gs.TweenMax;		import org.papervision3d.cameras.Camera3D;	import org.papervision3d.events.InteractiveScene3DEvent;	import org.papervision3d.materials.BitmapFileMaterial;	import org.papervision3d.objects.DisplayObject3D;	import org.papervision3d.objects.parsers.DAE;	import org.papervision3d.objects.primitives.Plane;	import org.papervision3d.scenes.Scene3D;	import org.papervision3d.view.Viewport3D;		import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.net.SharedObject;	import flash.utils.Timer;		/**	 * @author cmandell	 */	public class Control extends Sprite {		private var pLookToggle : Boolean;		private var pCamera : Camera3D;		private var pUniverse : DisplayObject3D;		private var pCloud : DAE;		private var pDolly : DisplayObject3D;		private var pDefaultZoom : Number = 100;		private var pDefaultFocus : Number = 8;		private var pDAEloaded : Boolean;		private var pXMLloaded : Boolean;		private var pXML : XML;		private var pObjectNames : Array;		private var pRollOffMaterials : Array;		private var pRollOverMaterials : Array;		private var pRotations : Array;		private var pInitChildComplete : Boolean;		private var pRotationSpeed : Number;		private var pViewPort : Viewport3D;		private var pObject : Object;		private var pObjectName : String;		private var pSpeed : Array;		private var pLimit : Array;		private var pInitDrift : Boolean;		private var pDirection : Array = new Array();		private var pCoordinates : Array = new Array();		private var pOrientationIndex : int = 100;		private var pDummy : DisplayObject3D = new DisplayObject3D();		private var pScene : Scene3D;		private var pRotateChildren : Boolean = true;		private var pIcon : Plane;		private var pReset : Boolean = true;		private var pMC : Plane;		private var pMaterial : BitmapFileMaterial;		public function Control() {						this.addEventListener(Event.ENTER_FRAME, renderLoop);			this.addEventListener(Event.ENTER_FRAME, setObjectListeners);//			this.addEventListener(Event.ENTER_FRAME, controlDrift);		}						private function setObjectListeners(e : Event) : void {									if (pXMLloaded && pDAEloaded) {				this.removeEventListener(Event.ENTER_FRAME, setObjectListeners);								pObjectNames = [];				for (var i : Number = 0;i < pXML.object.length(); i++) {					var _name : String = pXML.object[i].@name;					pObjectNames.push(_name);											pCloud.setChildMaterialByName(_name, pRollOffMaterials[i]);							pCloud.getChildByName(_name, true).addEventListener(InteractiveScene3DEvent.OBJECT_OVER, myRollOver);					pCloud.getChildByName(_name, true).addEventListener(InteractiveScene3DEvent.OBJECT_OUT, myRollOut);					pCloud.getChildByName(_name, true).addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, myClick);				}			}		}														public function lineUpObjectWithCamera(rObject : Object) : void {			pLookToggle = true;			pRotateChildren = false;			turnOffObjectListeners();			var _target : Object = rObject;			var _ObjectName : String = parseObjectName(_target);									pCloud.getChildByName(pObjectName, true).removeEventListener(InteractiveScene3DEvent.OBJECT_OUT, myRollOut);			pCloud.getChildByName(pObjectName, true).removeEventListener(InteractiveScene3DEvent.OBJECT_OVER, myRollOver);						var _object : DisplayObject3D = pCloud.getChildByName(_ObjectName, true);									var _result : Number = computeDegreesToRotate(_object);					TweenMax.to(pDolly, 2, {y:_object.sceneY});			TweenMax.to(_object, 3, {rotationX:0, rotationY:0, rotationZ:0, onComplete:moveIcon});							if (_object.sceneX >= 0) {				TweenMax.to(pUniverse, 2, {rotationY:pUniverse.rotationY + _result});			}else {								TweenMax.to(pUniverse, 2, {rotationY:pUniverse.rotationY - _result});			}						TweenMax.to(pCamera, 2, {zoom:140});			TweenMax.to(pCamera, 2, {focus:12});			var _delay : uint = 8000;			var _repeat : uint = 1;			var _timer : Timer = new Timer(_delay, _repeat);			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);			_timer.start();		}		private function moveIcon() : void {			pIcon.x = (pCamera.x) + 25;			pIcon.y = pCamera.y;			pIcon.z = pCamera.z + 500;		}				public function parseObjectName(rObject : Object) : String {			var _object : Object = rObject;			var _objectString : String = String(_object);			var _stringArray : Array = _objectString.split(":");			return _stringArray[0];		}		private function completeHandler(e : TimerEvent) : void {			resetScene();			var test:SharedObject		}		public function resetScene() : void {					if (pReset) {				if (pMC) {					TweenMax.to(pMC, 1.5, {scale:.1, onComplete:removeAnimation});				}				trace("1");				pIcon.x = 1000;				pOrientationIndex = 100;				//			pUniverse.rotationY = 0;				TweenMax.to(pCamera, 2, {zoom:pDefaultZoom});				trace("2");				TweenMax.to(pCamera, 2, {focus:pDefaultFocus});				trace("3");				TweenMax.to(pDolly, 2, {y:0, onComplete:resetObjectRollOver});				trace("4");			}		}				private function resetObjectRollOver() : void {			pCloud.getChildByName(pObjectName, true).addEventListener(InteractiveScene3DEvent.OBJECT_OVER, myRollOver);			pCloud.getChildByName(pObjectName, true).addEventListener(InteractiveScene3DEvent.OBJECT_OUT, myRollOut);					var _index : Number = pObjectNames.indexOf(pObjectName);			pCloud.setChildMaterialByName(pObjectName, pRollOffMaterials[_index]);			turnOnObjectListeners();			pLookToggle = false;		}								private function removeAnimation() : void {			pScene.removeChild(pMC);		}		private function turnOffObjectListeners() : void {			for (var i : Number = 0;i < pObjectNames.length; i++) {				var _name : String = pObjectNames[i];				pCloud.getChildByName(_name, true).removeEventListener(InteractiveScene3DEvent.OBJECT_OVER, myRollOver);				pCloud.getChildByName(_name, true).removeEventListener(InteractiveScene3DEvent.OBJECT_OUT, myRollOut);				pCloud.getChildByName(_name, true).removeEventListener(InteractiveScene3DEvent.OBJECT_CLICK, myClick);			}		}		private function turnOnObjectListeners() : void {					for (var i : Number = 0;i < pObjectNames.length; i++) {				var _name : String = pObjectNames[i];				pCloud.getChildByName(_name, true).addEventListener(InteractiveScene3DEvent.OBJECT_OVER, myRollOver);				pCloud.getChildByName(_name, true).addEventListener(InteractiveScene3DEvent.OBJECT_OUT, myRollOut);				pCloud.getChildByName(_name, true).addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, myClick);			}		}				private function loadAnimationTexture() : void {						pMaterial = new BitmapFileMaterial("lib/images/Windows_1024x768.jpg");			pMaterial.smooth = true;			pMaterial.doubleSided = false;			pMaterial.interactive = true;			pMaterial.smooth = true;		}						private function displayAnimation() : void {			loadAnimationTexture();			//			var _texture : Toothpaste = new Toothpaste();			//			_texture.btn1.addEventListener(MouseEvent.ROLL_OVER, btn1RollOver);			//			_texture.btn1.addEventListener(MouseEvent.ROLL_OUT, btn1RollOut);			//			_texture.btn1.addEventListener(MouseEvent.CLICK, btn1Click);			//			var _material : MovieMaterial = new MovieMaterial(_texture, false, true, false);			//			_material.animated = true;			var _plane : Plane = new Plane(pMaterial, 307, 230, 5, 5);			pMC = _plane;			_plane.x = pCamera.x;			_plane.y = pCamera.y;			_plane.z = -525;			pScene.addChild(_plane);			_plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, callReset);		}		private function btn1RollOver(e : MouseEvent) : void {			trace("rolled over");			pViewPort.containerSprite.buttonMode = true;		}		private function btn1RollOut(e : MouseEvent) : void {			trace("rolled off");			pViewPort.containerSprite.buttonMode = false;		}		private function btn1Click(e : MouseEvent) : void {			trace("got clicked");		}																private function callReset(e : InteractiveScene3DEvent) : void {			pReset = true;			resetScene();		}		private function makeIcon() : void {						var _material : BitmapFileMaterial = new BitmapFileMaterial("lib/images/icon.png");			_material.smooth = true;			_material.doubleSided = false;			_material.interactive = true;			_material.smooth = true;			var _plane : Plane = new Plane(_material, 10, 10, 5, 5);			pIcon = _plane;			_plane.x = 3000;			_plane.y = -25;			_plane.z = 0;			pScene.addChild(_plane);			_plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, handleIconClick);			_plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, handleIconOver);			_plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, handleIconOut);		}		private function handleIconClick(e : InteractiveScene3DEvent) : void {			pReset = false;			displayAnimation();		}		private function handleIconOver(e : InteractiveScene3DEvent) : void {			pViewPort.buttonMode = true;		}		private function handleIconOut(e : InteractiveScene3DEvent) : void {			pViewPort.buttonMode = false;		}												private function rotateChildren() : void {			if (pInitChildComplete && pDAEloaded) {				if (pRotateChildren = true) {					for (var i : Number = 0;i < pObjectNames.length; i++) {						var _array : Array = pRotations[i];						var _object : DisplayObject3D = pCloud.getChildByName(pObjectNames[i], true);						if (i == pOrientationIndex) {										//NOTHING					}else {							if (_object.rotationX > 360) {								_object.rotationX = _object.rotationX - 360;								}							if (_object.rotationX < 0) {								_object.rotationX = _object.rotationX + 360; 								}												if (_object.rotationY > 360) {								_object.rotationY = _object.rotationY - 360;								}							if (_object.rotationY < 0) {								_object.rotationY = _object.rotationY + 360; 								}													if (_object.rotationZ > 360) {								_object.rotationZ = _object.rotationZ - 360;								}							if (_object.rotationZ < 0) {								_object.rotationZ = _object.rotationZ + 360; 								}												_object.rotationX += _array[0];							_object.rotationY += _array[1];							_object.rotationZ += _array[2];						}					}				}			}		}						private function myClick(e : InteractiveScene3DEvent) : void {			var _object : Object = e.target;			pObjectName = parseObjectName(_object);			pOrientationIndex = pObjectNames.indexOf(pObjectName);			pCloud.setChildMaterialByName(pObjectName, pRollOverMaterials[pOrientationIndex]);					lineUpObjectWithCamera(_object);		}		private function makeSelectedItemFaceCamera() : void {		}								private function myRollOver(e : InteractiveScene3DEvent) : void {			pViewPort.buttonMode = true;			pRotationSpeed = .25;			var _object : Object = e.target;			var _ObjectName : String = parseObjectName(_object);			var _index : Number = pObjectNames.indexOf(_ObjectName, 0);			var _ObjectMaterial : BitmapFileMaterial = pRollOverMaterials[_index];						pCloud.setChildMaterialByName(_ObjectName, _ObjectMaterial);		}		private function myRollOut(e : InteractiveScene3DEvent) : void {			pViewPort.buttonMode = false;			pRotationSpeed = 1;			var _object : Object = e.target;			var _ObjectName : String = parseObjectName(_object);			var _index : Number = pObjectNames.indexOf(_ObjectName, 0);			var _ObjectMaterial : BitmapFileMaterial = pRollOffMaterials[_index];						pCloud.setChildMaterialByName(_ObjectName, _ObjectMaterial);		}		private function renderLoop(myEvent : Event) : void {			mouseRotate();			rotateChildren();			//			if (pLookToggle) {			//				pCamera.lookAt(pObject)			//			}		}		public function mouseRotate() : void {			if (pDAEloaded) {				if (!pLookToggle) {					pUniverse.rotationY += 1;				}			}//				var xDist : Number = mouseX - stage.stageWidth * 0.5;//				var yDist : Number = mouseY - stage.stageHeight * 0.5;//				pUniverse.rotationY += xDist * 0.05;//				pCloud.rotationX += yDist * 0.05;//				pCloud.getChildByName("Bubbles", true).rotationY += xDist * 0.05;//				pCloud.getChildByName("Bubbles", true).rotationX += yDist * 0.05;//			}		}		public function computeDegreesToRotate(rObject : DisplayObject3D) : Number {			var _object : Object = rObject;			var _x1 : Number = 0;			var _z1 : Number = 0;			var _x2 : Number = _object.sceneX;			var _z2 : Number = _object.sceneZ;			var _x3 : Number = 0;			var _z3 : Number = 0;			var _x4 : Number = pCamera.x;			var _z4 : Number = pCamera.z;						var pt1 : Number = _x2 - _x1;			var pt2 : Number = _z2 - _z1;			var pt3 : Number = _x4 - _x3;			var pt4 : Number = _z4 - _z3;						var _angle : Number = ( (pt1 * pt3) + (pt2 * pt4) ) / ((Math.sqrt(pt1 * pt1 + pt2 * pt2)) * (Math.sqrt(pt3 * pt3 + pt4 * pt4)) );			var _result : Number = Math.acos(_angle) * 180 / Math.PI;			return _result;		}		public function setDAEProps(					 rViewport : Viewport3D,					 rUniverse : DisplayObject3D,					 rCamera : Camera3D, 					 rCloud : DAE,					 rDolly : DisplayObject3D,					 rScene : Scene3D) : void {			pViewPort = rViewport;			pUniverse = rUniverse;			pCamera = rCamera;			pCloud = rCloud;			pDolly = rDolly;			pScene = rScene;			makeIcon();		}		public function setPDAEloaded(rLoaded : Boolean) : void {			pDAEloaded = rLoaded;		}		public function setPLookToggle(rValue : Boolean) : void {			pLookToggle = rValue;			}		public function setXMLloaded(rLoaded : Boolean, rXML : XML) : void {						pXMLloaded = true;			pXML = rXML;		}						public function setRotationData(rValue : Boolean, rRotations : Array) : void {			pInitChildComplete = rValue;			pRotations = rRotations;			}		public function setDriftData(rInitDrift : Boolean, rSpeed : Array, rLimit : Array, rDirection : Array, rCoordinates : Array) : void {			pInitDrift = rInitDrift;			pSpeed = rSpeed;			pLimit = rLimit;			pDirection = rDirection;			pCoordinates = rCoordinates;		}						//		pControl.setObjectProperties(pObjectNames, pRollOffMaterials, pRollOverMaterials)		public function setObjectProperties(rObjectNames : Array, rRollOffMaterials : Array, rRollOverMaterials : Array) : void {			pObjectNames = rObjectNames;			pRollOffMaterials = rRollOffMaterials;			pRollOverMaterials = rRollOverMaterials;			}	}}