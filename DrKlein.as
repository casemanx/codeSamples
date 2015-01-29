
package {
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;

	//import gs.TweenLite;

			

	/**
	 * @author cman
	 */
	public class DrKlein extends MovieClip {
		private var frame2Clips : Array;
		private var pCurrentClip : MovieClip;
		private var pVideoRollOverClicked : Boolean = false;
		private var pBarClips : Array;
		private var pBarHeights : Array;
		private var pBarYPosition : Array;
		private var pBarYPositions : Array;
		private var pTimeLineLite : TimelineLite;
		private var pHeight : Number;
		private var pVideoStream : NetStream
		private var pDuration : Number;
		//
		private var pNameFaded : Boolean = false;
		private var pBkgdTxt2FadedIn : Boolean = false;
		private var pScrubBarXpos : Number;
		private var pScrubBar : MovieClip;
		private var pDragArea : MovieClip;
		private var pDragAreaXpos : Number;
		//
		private var pTimer : Timer;
		private var pScrubBarTimer : Timer;
		private var pVideoPlayed : Boolean = false;

		private var f2Xpos : *;
		private var f2Ypos : *;
		private var f2ScaleY : *;
		private var f2ScaleX : *;
		private var replayCounter : int = 0;
		private var pVideoComplete : Boolean;

		public function DrKlein() {
			stop();
			getF2Values();
			TweenPlugin.activate([AutoAlphaPlugin]);
			initApp();
			loadVideo();
			playVideoBtn2Init();
			playOpeningSequence();
		}

		private function initApp() : void {
			frame1Init();
			frame2Init();
			visitNowBtnInit();
			bkgdInit();
			//			videoRollOverInit();
			barsInit();
			videoInit();
			scrubBarInit();
			CtrlBarInit();
		}

		
		
		private function getF2Values() : void {
			f2Xpos = f2.frame2.bars.x;
			f2Ypos = f2.frame2.bars.y;
			f2ScaleX = f2.frame2.bars.scaleX;
			f2ScaleY = f2.frame2.bars.scaleY;
		}

		private function frame1Init() : void {
			TweenLite.to(f1, 0, {autoAlpha:1})
			f1.f1txt.visible = false
			f1.f1txt.alpha = 0;
			pCurrentClip = f1;
		}

		private function frame2Init() : void {
			f2.visible = false;
			f2.alpha = 0;
			frame2Clips = [f2.frame2.meningoTxt, f2.frame2.txt1,f2.frame2.txt2, f2.frame2.xAxis, f2.frame2.yAxis,f2.f2Top, f2.factsOnBar]
			for (var i : int = 0;i < frame2Clips.length;i++) {
				frame2Clips[i].visible = false;
				frame2Clips[i].alpha = 0;
			}		
		}

		
		private function bkgdInit() : void {
			bkgd.visible = true;
			bkgd.alpha = 1;
			
			bkgd.myVideo.visible = 0;
			bkgd.myVideo.alpha = 0;
			
			TweenLite.to(bkgd.bkgdTxt, 0, {autoAlpha:0})
			//			TweenLite.to(bkgd.bkgdTxt.txt2, 0, {autoAlpha:0})
			TweenLite.to(bkgd.bkgdTxt.txt3, 0, {autoAlpha:0})

			bkgd.bkgdTxt.replayBtn.buttonMode = true;			
			bkgd.bkgdTxt.replayBtn.addEventListener(MouseEvent.MOUSE_DOWN, replayBtnDown)			
			
			TweenLite.to(bkgd.nameTxt, 0, {autoAlpha:1});
			
			bkgd.closeBtn.buttonMode = true;
			bkgd.closeBtn.useHandCursor = true;
			bkgd.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN, closeBtnDown)
		}

		private function playVideoBtn2Init() : void {
			playVideoBtn2.buttonMode = true;
			playVideoBtn2.addEventListener(MouseEvent.MOUSE_OVER, playVideoBtnDown);
		}

		
		private function videoRollOverInit() : void {
			
			f1.playVideoBtn.buttonMode = true;
			f1.playVideoBtn.addEventListener(MouseEvent.MOUSE_OVER, playVideoBtnDown);
			
			f2.f2Top.playVideoBtn.buttonMode = true;
			f2.f2Top.playVideoBtn.addEventListener(MouseEvent.MOUSE_OVER, playVideoBtnDown);
		}

		private function playVideoBtnDown(e : MouseEvent) : void {
			
			playVideoBtn2.visible = false;
			playVideoBtn2.removeEventListener(MouseEvent.MOUSE_OVER, playVideoBtnDown);
			pTimeLineLite.pause();
			resetScrubber();
			pScrubBarTimer.start();
			f1.playVideoBtn.buttonMode = false;
			f1.playVideoBtn.removeEventListener(MouseEvent.MOUSE_OVER, playVideoBtnDown)

			f2.f2Top.playVideoBtn.buttonMode = false;
			f2.f2Top.playVideoBtn.removeEventListener(MouseEvent.MOUSE_OVER, playVideoBtnDown)
			
			if (pVideoPlayed) {
				TweenLite.to(bkgd.myVideo, .5, {autoAlpha:1, onComplete:myResumeVideo});
			} else {
			
				TweenLite.to(bkgd.myVideo, .5, {autoAlpha:1, onComplete:myPlayVideo});
			}
			
			TweenLite.to(bkgd, .5, {x:0, autoAlpha:1, onComplete:resetScrubber});
			
			TweenLite.to(f1, .5, {autoAlpha:0});
			TweenLite.to(f2, .5, {autoAlpha:0});
				
//			TweenLite.to(pCurrentClip, .5, {autoAlpha:0, onComplete:failSafe});
		}

		private function myResumeVideo() : void {
			pVideoStream.resume();
		}

		private function myPlayVideo() : void {
			playMyVideo();
		}

		
		private function closeBtnDown(e : MouseEvent) : void {
			var _duration : Number = 1
			playVideoBtn2.visible = true;
			replayCounter = 0;
			pScrubBarTimer.stop();
			TweenLite.to(bkgd, _duration, {x:200, onComplete:replayOpeningSequence});
			TweenLite.to(bkgd.myVideo, _duration, {autoAlpha:0});
			TweenLite.to(bkgd.bkgdTxt, _duration, {autoAlpha:0});
			TweenLite.to(playVideoBtn2, 1, {x:playVideoBtn2.x, delay:1, onComplete:reInitVideoRollOver})
		
			//			scrubBarInit();	
			pVideoPlayed = true;
			resetVideo();
		}

		private function replayBtnDown(e : MouseEvent) : void {
			//			var mc : MovieClip = bkgd.myVideo.ctrlBar.ctrlBtn;
			//			mc.myPauseBtn.visible = true;
			//			mc.myPlayBtn.visible = false;

			resetVideo();
			TweenLite.to(bkgd.nameTxt, .5, {autoAlpha:1})
			TweenLite.to(bkgd.myVideo, .5, {autoAlpha:1});
			TweenLite.to(bkgd.bkgdTxt, .5, {autoAlpha:0, onComplete:myResumeVideo});
			TweenLite.to(bkgd.bkgdTxt.txt3, .5, {autoAlpha:0})
			pScrubBarTimer.start();	
		}

		
		private function replayOpeningSequence() : void {
			//			var _timer = new Timer(3000, 1)
			//			_timer.addEventListener("timer", reInitVideoRollOver)
			//			_timer.start();

			makeBarsEqualHeight();
			frame1Init();
			frame2Init();
			visitNowBtnInit();
			bkgdInit();
			pTimeLineLite.restart();
		}

		private function reInitVideoRollOver() : void {
			playVideoBtn2.visible = true;
			playVideoBtn2.addEventListener(MouseEvent.MOUSE_OVER, playVideoBtnDown);
//			videoRollOverInit();
		}

		private function getbarsInits() : void {
			var mc : MovieClip = f2.frame2.bars;
			trace("mc.visible   = " + mc.visible);
			trace("mc.alpha   = " + mc.alpha);
			trace("mc.x   = " + mc.x);
			trace("mc.y   = " + mc.y);
			trace("mc.width   = " + mc.width);
			trace("mc.height   = " + mc.height);
		}

		
		
		private function loopSequence() : void {
			pVideoComplete = true;
			
			if (replayCounter < 1) {

				TweenLite.to(f1, .5, {autoAlpha:1});
				TweenLite.to(f2, .5, {autoAlpha:0});
				replayCounter++
				resetf2();
				frame1Init();
				frame2Init();
				visitNowBtnInit();
				bkgdInit();
		
				//				videoRollOverInit();
				barsInit();
				videoInit();
				//				scrubBarInit();

				CtrlBarInit();

				//				initApp();
				f1.f1txt.visible = false
				f1.f1txt.alpha = 0;
				//

				playOpeningSequence();
			}
		}

		private function resetf2() : void {
			f2.frame2.bars.scaleX = f2ScaleX;
			f2.frame2.bars.scaleY = f2ScaleY;
			f2.frame2.bars.x = f2Xpos;
			f2.frame2.bars.y = f2Ypos;
		}

		
		
		private function barsInit() : void {
			var mc : MovieClip = f2.frame2.bars
			pBarClips = [mc.b0, mc.b1, mc.b2, mc.b3, mc.b4, mc.b5, mc.b6, mc.b7, mc.b8, mc.b9, mc.b10, mc.b11, mc.b12, mc.b13, mc.b14, mc.b15, mc.b16, mc.b17, mc.b18, mc.b19, mc.b20, mc.b21, mc.b22, mc.b23, mc.b24, mc.b25]
			pBarHeights = [];
			pBarYPositions = [];
			
			for (var i : int = 0;i < pBarClips.length;i++) {
				
				var _height : int = pBarClips[i].height;
				var yPosition : int = pBarClips[i].y;
				pBarHeights.push(_height);
				pBarYPositions.push(yPosition);
			}
			pHeight = pBarClips[0].height
			makeBarsEqualHeight();
		}

		private function makeBarsEqualHeight() : void {
			for (var j : int = 0;j < pBarClips.length;j++) {
				pBarClips[j].height = pHeight;
				pBarClips[j].y = pBarClips[0].y;
			}	
		}

		private function visitNowBtnInit() : void {
			var mc : MovieClip = f2.factsOnBar.visitNowBtn;
			mc.buttonMode = true;
			mc.addEventListener(MouseEvent.MOUSE_DOWN, visitNowBtnDown);

			mc = bkgd.visitNowBtn;
			mc.buttonMode = true;
			mc.addEventListener(MouseEvent.MOUSE_DOWN, visitNowBtnDown);
		}

		private function visitNowBtnDown(e : MouseEvent) : void {
//			var mc : MovieClip = bkgd.myVideo.ctrlBar.ctrlBtn;
//			mc.myPlayBtn.visible = true;
//			pVideoStream.pause();
//			mc.myPauseBtn.visible = false;
//			var request : URLRequest = new URLRequest("http://www.factsonmeningitis.com");
//			navigateToURL(request);
//			
//			
			
			
//			var url : String = "http://www.factsonmeningitis.com";
//			var request : URLRequest = new URLRequest(url);
//			navigateToURL(request, '_blank');
		}

		private function playOpeningSequence() : void {
			pTimeLineLite = new TimelineLite();
			pTimeLineLite.insert(TweenLite.to(f1.f1txt, .5, {delay:.5, autoAlpha:1}));
			pTimeLineLite.insert(TweenLite.to(f1, .5, {autoAlpha:0}), 3);
			pTimeLineLite.insert(TweenLite.to(f2, .5, {autoAlpha:1, onComplete:currentClipf2}), 3);
			pTimeLineLite.insert(TweenLite.from(f2.frame2, 3, {autolpha:0, x:"-400"}), 2);
			pTimeLineLite.insert(TweenLite.to(f2.frame2.bars, 1, {scaleX:1, scaleY:1, x:158.3, y:124.8}), 4);
			pTimeLineLite.insert(TweenLite.to(bkgd, 2, {autoAlpha:0}), 3)
			pTimeLineLite.insert(TweenLite.to(f2.frame2.meningoTxt, 1, {onComplete:resizeBars}), 2.75);
			pTimeLineLite.insert(TweenLite.to(f2.f2Top, .25, {autoAlpha:1}));
			pTimeLineLite.insert(TweenLite.to(f2.factsOnBar, 2, {autoAlpha:1}));
			pTimeLineLite.insert(TweenLite.to(f2.frame2.meningoTxt, 1, {autoAlpha:1}), 5);
			pTimeLineLite.insert(TweenLite.to(f2.frame2.xAxis, 1, {autoAlpha:1}), 5);
			pTimeLineLite.insert(TweenLite.to(f2.frame2.yAxis, 1, {autoAlpha:1}), 5);
			pTimeLineLite.insert(TweenLite.to(f2.frame2.txt1, 1, {autoAlpha:1}), 6);
			pTimeLineLite.insert(TweenLite.to(f2.frame2.txt2, 1, {autoAlpha:1, onComplete:loopSequence}), 8);
//			pTimeLineLite.insert(TweenLite.to(f2.frame2.txt2, 1, {autoAlpha:1}), 8);
		}

		private function currentClipf2() : void {
			pCurrentClip = f2;
		}

		private function resizeBars() : void {
			for (var i : int = 0;i < pBarClips.length;i++) {
				var _clip : MovieClip = pBarClips[i];
				var _height : int = pBarHeights[i];
				var _yPos : int = pBarYPositions[i];
				TweenLite.to(_clip, 1, {height:_height, y:_yPos})
			}
		}

		private function videoInit() : void {
			var mc : MovieClip = bkgd.myVideo.ctrlBar.ctrlBtn;
			mc.buttonMode = true;	
			mc.addEventListener(MouseEvent.MOUSE_DOWN, toggleVideo)
			mc.myPlayBtn.visible = false;
			
			mc = bkgd.myVideo.ctrlBar.soundBtn;
			mc.buttonMode = true;
			mc.addEventListener(MouseEvent.MOUSE_DOWN, toggleSound)
			mc.blackSoundBtn.visible = false;
		}

		
		private function CtrlBarInit() : void {
			
			pScrubBar.addEventListener(MouseEvent.MOUSE_DOWN, dragScrubber);
			pScrubBar.addEventListener(MouseEvent.MOUSE_UP, stopDragScrubber);
			//			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragScrubber);
			pTimer = new Timer(100);
			pTimer.addEventListener(TimerEvent.TIMER, scrubVideo);
			//			pTimer.start();
			pScrubBarTimer = new Timer(100);
			pScrubBarTimer.addEventListener(TimerEvent.TIMER, syncScrubber);
//			pScrubBarTimer.start();
		}

		private function scrubBarInit() : void {
			pScrubBar = bkgd.myVideo.ctrlBar.scrubberBar;
			pScrubBarXpos = pScrubBar.x
			pScrubBar.x = pScrubBarXpos + pScrubBar.width;
			pScrubBar.visible = false; 
			pScrubBar.buttonMode = true;
			
			pDragArea = bkgd.myVideo.ctrlBar.dragArea;
			pDragAreaXpos = pDragArea.x;
			pDragArea.x = pScrubBar.x;
			pDragArea.visible = false;
		}

		private function loadVideo() : void {
			var videoConnection : NetConnection = new NetConnection();
			videoConnection.connect(null);
			
			pVideoStream = new NetStream(videoConnection);
			var _clientObject = new Object();
			_clientObject.onMetaData = onMetaData;
			pVideoStream.client = _clientObject;

			var video : Video = new Video(299, 190);
			bkgd.myVideo.videoHolder.addChild(video);
			video.attachNetStream(pVideoStream);
		}

		private function playMyVideo() : void {
			pVideoStream.play("flv/DrKlein.flv");
		}

		
		private function toggleVideo(e : MouseEvent) : void {
			var mc : MovieClip = bkgd.myVideo.ctrlBar.ctrlBtn;

			if (mc.myPauseBtn.visible == true) {
				mc.myPlayBtn.visible = true;
				pVideoStream.pause();
				mc.myPauseBtn.visible = false;
			} else {
				mc.myPauseBtn.visible = true;
				mc.myPlayBtn.visible = false;
				pVideoStream.resume();
			}
		}

		private function toggleSound(e : MouseEvent) : void {
			var mc : MovieClip = bkgd.myVideo.ctrlBar.soundBtn
			
			if (mc.redSoundBtn.visible == true) {
				pVideoStream.soundTransform = new SoundTransform(0);
				mc.redSoundBtn.visible = false;
				mc.blackSoundBtn.visible = true;
			} else {
				pVideoStream.soundTransform = new SoundTransform(1);
				mc.redSoundBtn.visible = true;
				mc.blackSoundBtn.visible = false;
			}
		}

		
		
		private function onMetaData(onMetaData : Object) : void {
			pDuration = onMetaData.duration;
		}

		
		private function dragScrubber(e : MouseEvent) : void {
			trace("drag Scrubber");
			var mc : MovieClip = bkgd.myVideo.ctrlBar.ctrlBtn;
			mc.myPauseBtn.visible = false;
			mc.myPlayBtn.visible = true;
			pVideoStream.pause();
			pScrubBarTimer.stop();
			pTimer.start();
			pScrubBar.startDrag(false, new Rectangle(pDragArea.x, pDragArea.y, pDragArea.width-10, 0));
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragScrubber);
		}

		private function stopDragScrubber(e : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragScrubber);
			pScrubBar.stopDrag();
			pTimer.stop();
			var mc : MovieClip = bkgd.myVideo.ctrlBar.ctrlBtn;
			mc.myPauseBtn.visible = true;
			mc.myPlayBtn.visible = false;
			
			pScrubBarTimer.start();
			pVideoStream.resume();
		}

		private function syncScrubber(e : TimerEvent) : void {
			var mc : MovieClip = bkgd.myVideo.ctrlBar.ctrlBtn;
			var _time : Number = pVideoStream.time;
			
			//			trace("syncScrubber");		
			if (_time > pDuration - .05) {
				trace("stopped");
				resetVideo();
				pNameFaded = false;
				TweenLite.to(bkgd.myVideo, .5, {autoAlpha:0});
				TweenLite.to(bkgd.bkgdTxt, .5, {autoAlpha:1, onComplete:tweenTxt3});
				TweenLite.to(bkgd.nameTxt, .5, {autoAlpha:0});
			} else {
				var _offSet : Number = pDragArea.x;
				var _percent : Number = _time / pDuration;
				var _Xpos = _percent * pDragArea.width;
				_Xpos = _Xpos + _offSet;
				pScrubBar.x = _Xpos;
			}
		}

		private function tweenTxt3() : void {
			TweenLite.to(bkgd.bkgdTxt.txt3, .5, {autoAlpha:1, delay:2.5})
		}

		
		private function resetVideo() : void {
			//			resetScrubber();

			var mc : MovieClip = bkgd.myVideo.ctrlBar.ctrlBtn;
			mc.myPauseBtn.visible = true;
			mc.myPlayBtn.visible = false;
			
			mc = bkgd.myVideo.ctrlBar.soundBtn
			mc.redSoundBtn.visible = true;
			mc.blackSoundBtn.visible = false;

			
			pVideoStream.soundTransform = new SoundTransform(1);
			pVideoStream.seek(0)
			pVideoStream.pause();
			pNameFaded = false;
			pScrubBar.x = pScrubBarXpos + pScrubBar.width;
		}

		
		
		private function resetScrubber() : void {
			pScrubBar.x = pScrubBarXpos;
			pScrubBar.visible = true;
			pDragArea.x = pDragAreaXpos;
			pDragArea.visible = true
		}

		private function scrubVideo(e : TimerEvent) : void {
			var _offSet : Number = pDragArea.x
			var _percent : Number = (pScrubBar.x - _offSet) / pDragArea.width;
			var _position : Number = _percent * pDuration;
			pVideoStream.seek(_position - .5);
		}
	}
}
