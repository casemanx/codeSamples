var my = {};
/*
my.txtDoneLoading = false;
my.imagesDoneLoading = false;
my.containerList =[];
*/
my.restart =0;
var loaderBar;
var Stage;
var bar;
var imageContainer;
var currentImage;
var loaderWidth;
var loaderColor;
var borderPadding;
var preload;
var oldItem;


$(document).ready (function() {
    my.Canvas = $("#testCanvas")[0];
    my.Stage = new createjs.Stage(my.Canvas);

    initImages();

});




function initImages() {
    borderPadding = 10;
    manifest = [
        {src:"background_02.jpg", id:"bkgd"},
        {src:"henryFord_01.jpg", id:"hf"},
        {src:"skyCarLeft.png", id:"carLeft"},
        {src:"skyCarRight.png", id:"carRight"},
        {src:"tire_01.png", id:"tire"}];

    preload = new createjs.LoadQueue(true, "test/");
    preload.on("progress", handleProgress);
    preload.on("complete", handleComplete);
    preload.on("fileload", handleFileLoad);
    preload.on("error", handleErrors);
    preload.on("fileprogress", handleFileProgress);
    preload.loadManifest(manifest, true, "src/images/");
}


function handleFileLoad(event) {
    var testing;
    var image=event.result;
    var w;
    var h;
    var myIndex;
    var bmp;
    var border;
    var myContainer;

    w=image.width;
    h=image.height;

    bmp = new createjs.Bitmap(image).set({regX: w/2,regY: h/2});

    border = new createjs.Shape(new createjs.Graphics().beginFill(null).drawRect(0, 0, w + borderPadding, h + borderPadding).endFill()
    ).set({regX: w/2,regY: h/2});

    myContainer = new createjs.Container();
    myContainer.addChild(border, bmp);
    myContainer.name = event.item.id;

    switch (event.item.id) {
    case "bkgd":
            my.bkgd = bmp;

            break;
        case "hf":
            my.hf = bmp;
            break;
        case "carLeft":
            my.carLeft = bmp;
            break;
        case "carRight":
            my.carRight = bmp;
            break;
        case "tire":
            my.tire1 = bmp;
            my.tire2 = my.tire1.clone();
            my.tire3 = my.tire1.clone();
            my.tire4 = my.tire1.clone();


            break;
        default:
            break;
    }
};

function handleComplete(event) {
    initTitles();
    configureStage();
    animationSetup();
};
function handleErrors(event){
    //console.log("ErrorEvent = "+ event)
}
function handleFileProgress(event){
    //console.log("fieProgressEvent = "+ event)
}
function handleProgress(event){
}
function initTitles() {
    var myTxt;
    var myName;
    var myTitles = {
        myColor: "red",
        myX: -400,
        myY: 25,
        myFont: "bold 28px Arial",
        myH1: "Move Over\nHenry Ford",
        myH2: "and take Your\nTires with You",
        myH3: "Announcing the\nAmazing New\nAeromatic\nFlying Car",
        myH4: "If its\nnot Aeromatic\nChances are\nSomething Stinks"};

    myTxt = new createjs.Text(myTitles.myH1, myTitles.myFont, myTitles.myColor);
    myName="H1";
    initializeTxt(myTxt, "right", myTitles.myX, myName);

    myTxt = new createjs.Text(myTitles.myH2, myTitles.myFont, myTitles.myColor);
    myName = "H2";
    initializeTxt(myTxt, "right", myTitles.myX, myName);

    myTxt = new createjs.Text(myTitles.myH3, myTitles.myFont, myTitles.myColor);
    myName = "H3";
    initializeTxt(myTxt, "center", myTitles.myX, myName);

    myTxt = new createjs.Text(myTitles.myH4, myTitles.myFont, myTitles.myColor);
    myName = "H4";
    initializeTxt(myTxt, "center", myTitles.myX, myName);
};

function initializeTxt(myTxt, txtAlign, myX, myName) {
    var w;
    var h;
    var border;
    var myContainer;

    w = myTxt.getMeasuredWidth();
    h = myTxt.getMeasuredHeight();

    myTxt.textAlign = txtAlign;
    myTxt.x=0;
    myTxt.y=0;
    myTxt.regX=w/2;
    myTxt.regY=h/2;

    border = new createjs.Shape(new createjs.Graphics().beginFill(null).drawRect(0, 0, myTxt.getMeasuredWidth(), myTxt.getMeasuredHeight()).endFill()
    ).set({
            x:0,
            y:0,
            scaleX: myTxt.scaleX,
            scaleY: myTxt.scaleY,
            });

    myContainer = new createjs.Container();
    myContainer.addChild(border, myTxt);
    myContainer.name = myName;

    switch (myName){
        case "H1":
            my.H1 = myTxt;
        break;
        case "H2":
            my.H2 = myTxt;
            break;
        case "H3":
            my.H3 = myTxt;
            break;
        case "H4":
            my.H4 = myTxt;
            break;}
    };
//position elements
function configureStage() {
    my.bkgd.x = 150;
    my.bkgd.y = 125;
    my.bkgd.alpha = 1;

    my.hf.x = 244;
    my.hf.y = 156;
    my.hf.alpha = 0;

    my.H1.x = -100;//starting x
    my.H1.y = 150;
    my.H1.skewX = -19;
    my.H1.alpha =1;

    my.H2.x = 480;//ending x
    my.H2.y = 150;
    my.H2.alpha = 0;

    my.carRight.x = -120;//
    my.carRight.y = 184;
    my.carRight.alpha = 1;
    my.carRight.rotation =-15;
    my.carRight.alpha = 1;

    my.H3.x = 500;
    my.H3.y = 75;
    my.H3.alpha = 0;

    my.H4.x = 485;
    my.H4.y = 70;
    my.H4.alpha = 0;

    my.carLeft.x = 420;// first x stop;
    my.carLeft.y = 175;
    my.carLeft.alpha = 1;
    my.carLeft.rotation = 15;
    my.carLeft.alpha = 1;

    my.tire1.x = 100;
    my.tire1.y = 125;
    my.tire1.skewY = -50;
    my.tire1.skewX = 20;
    my.tire1.rotation = 164;
    my.tire1.alpha = 0;

    my.tire2.x = 76;
    my.tire2.y = 175;
    my.tire2.skewY = -50;
    my.tire2.skewX = 20;
    my.tire2.rotation = 164;
    my.tire2.scaleX = .6;
    my.tire2.scaleY = .6;
    my.tire2.alpha = 0;

    my.tire3.x = 238;
    my.tire3.y = 198;
    my.tire3.skewY = 29;
    my.tire3.skewX = 16;
    my.tire3.rotation = 289;
    my.tire3.scaleX = .6;
    my.tire3.scaleY = .6;
    my.tire3.alpha = 0;

    my.tire4.x = 238;
    my.tire4.y = 84;
    my.tire4.skewY = -20;
    my.tire4.skewX = 16;
    my.tire4.rotation = 289;
    my.tire4.scaleX = .6;
    my.tire4.scaleY = .6;
    my.tire4.alpha = 0;

    my.Stage.update();
    createjs.Ticker.setFPS(60);
    /*++++++++++++++++++++++++++++++++++++++*/
}

function animationSetup(){

    if ((my.Stage.getChildAt(0)) !== (my.bkgd))
     {
        my.Stage.addChildAt(my.bkgd,0);
    }


    function loadSection1() {
        my.Stage.addChild(my.hf, my.H1, my.H2, my.H3, my.H4, my.carLeft, my.carRight, my.carLeft, my.tire1, my.tire2, my.tire3, my.tire4);
        my.Stage.update();
    }

    loadSection1();
    Animation();

}

function Animation() {
    var t1 = new TimelineMax();

    t1.to(my.bkgd, 1, {alpha: 1}).
        to(my.hf, 1, {alpha: 1, delay: 1}).
        to(my.H1, 2, {x: 323}).
        to(my.H1, 2, {skewX: 1, delay: -.5}).
        to(my.H1, .5, {x: 315, skewX: -19}).
        to(my.H1, 2, {x: 440, skewX: 1}).
        to(my.hf, 2, {x: 380, delay: -2}).
        to(my.H1, 1, {alpha: 0, delay: .5}).

        to([my.tire1, my.tire2, my.tire3, my.tire4], 3, {alpha: 1, delay: -.5}).

        to(my.tire1, 2, {x: 300, y: 350}).
        to(my.tire2, 2, {x: 200, y: 350, delay: -3}).
        to(my.tire3, 2, {x: 150, y: 350, delay: -3}).
        to(my.tire4, 2, {x: 150, y: 350, delay: -3}).
        to(my.H2, 1, {alpha: 1}).
        to([my.tire1, my.tire2, my.tire3, my.tire4], .5, {alpha: 0}).
        to(my.H2, 1, {alpha: 0, delay:1}).
        to(my.H3, 1, {alpha: 1}).
        to(my.carRight, 2, {x: 157, rotation: 0}).
        to(my.carRight, 1, {y: 190}).
        to(my.carRight, 1, {y: 184, delay: 2}).
        to(my.carRight, 2, {x: 500, rotation: -15}).
        to(my.H3, 2, {alpha: 0}).
        to(my.H4, 2, {alpha: 1}).
         to(my.carLeft, 2, {x: 150, rotation: 0, delay:-2}).
        to(my.carLeft, 1, {y: 190}).
        to(my.carLeft, 1, {y: 184}).
        to(my.carLeft, 1, {y: 190}).
        to(my.carLeft, 1, {y: 184}).
        to(my.carLeft, 1, {y: 190}).
        to(my.carLeft, 1, {y: 184}).
        to(my.carLeft, 1, {y: 190}).
        to(my.carLeft, 1, {y: 184}).
        to(my.H4, 1, {alpha:0}).
        to(my.carLeft, 1, {y: 190, alpha:0, delay:-1, onComplete: replayBanner})
}


function replayBanner(){
    if (my.restart < 3) {

        for (var i = 1; i < my.Stage.length - 1; i++) {
            my.Stage.removeChildAt(i);
        }

    }
        my.Stage.removeAllChildren();
        configureStage();
        animationSetup();
        my.restart += 1;
   }


/*

var controls;
controls = new function ()
    {
    this.posX = 150;
    this.posY = 125;
    this.mySkewY = 1;
    this.mySkewX = 1;
    this.myRotation = 0;

    };

var gui = new dat.GUI();
    gui.add(controls, "posX", -100,500);
    gui.add(controls, "posY", -250, 450);
    gui.add(controls, "mySkewY", -50, 50);
    gui.add(controls, "mySkewX", -50, 50);
    gui.add(controls, "myRotation", 0, 360);
    gui.add(controls,"posX1").listen();

var that = this;
*/
function tickerFunction()
    {
    var obj1 = my.H3;
    obj1.x = controls.posX;
    obj1.y = controls.posY;
    obj1.skewX=controls.mySkewX;
    obj1.skewY=controls.mySkewY;
    obj1.rotation = controls.rotation;
    }

createjs.Ticker.addEventListener("tick", function()
        {
      //  tickerFunction();
        my.Stage.update();

        });












