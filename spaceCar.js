/**
 * @author Casey Mandell
 */


var myNum = 1;
var gameOver = false;
var virusScore = 0;
var playerScore = 0;
var germId = 0;
var germRotationList = [2,3,4,5,2,3,4,5];

var myPlayer = $("#player");
var myHeading = $("#heading");
var myPlayField = $("#myPlayField");
var myControls = $("#controls");
var myRules = $("#rules");
var myshortcutKeys = $("#shortcutKeys");

var gameInterval;
var reStartInterval;

var myWindowSize = getWindowSize();



function initializePlayer(){
myPlayer.data("numberOfCollisions", 0);
myPlayer.data("collisionLimit", 3);
myPlayer.data("amountToRotate", 0);
myPlayer.data("currentRotation", 0);
myPlayer.data("ax", 0);
myPlayer.data("ay", 0);
myPlayer.data("speed", 0);
myPlayer.data("animatePlayer", false);
myPlayer.data("whichKey", null);
myPlayer.data("rotationText", null);
myPlayer.data("top", null);
myPlayer.data("left", null);
myPlayer.data("angle", 0);
myPlayer.data("keyList", []);
myPlayer.data("collided", false);
myPlayer.data("myColor", "red");
    var playerLeft = myPlayField.offset().left + 50;
    var playerTop = myPlayField.offset().top+50;
    myPlayer.offset({left: playerLeft, top:playerTop});
}


var gameBorders = {};

gameBorders.myOffSet = 15;
var myTop = myPlayer.position().top;
    gameBorders.myTop = myTop;

var myRight = myPlayer.position().left;
    myRight += myPlayField.width();
    myRight -= myPlayer.height();
    gameBorders.myRight = myRight;

var myBottom = myPlayer.position().top + myPlayField.height();
    myBottom -= myPlayer.height();
    gameBorders.myBottom = myBottom;


var myLeft = myPlayer.position().left;
    myLeft += gameBorders.myOffSet;
    gameBorders.myLeft = myLeft;


function intializeshortcutKeys()
{
    var left = gameBorders.myRight+50;
        //gameBorders.myRight+50;
     var top =gameBorders.myTop;

    $("#shortcutKeys").offset({left:left, top:top});

}

$(document).ready(function(){
    initializeGame();
});



function updateGame() {


    if (myPlayer.data("animatePlayer")) {
        setNewPlayerValues(myPlayer);
        animatePlayer(myPlayer);
    }
    animateGerms();
}
   // doCollisionTest();


function initializeGame(){
    virusScore = 0;
    playerScore = 0;
    gameOver = false;
    $("#virusScore").html(virusScore);
    $("#playerScore").html(playerScore);

    $("div").hide();

    $("div").delay(1000).fadeIn();
    initializePlayer();
    intializeGerms();
    intializeshortcutKeys();
    clearInterval(reStartInterval);

   gameInterval = setInterval(updateGame, 10);

}

function reInitializeGame()
{
    clearInterval(reStartInterval);
   myPlayer.data("checkForCollisions", true);
    virusScore = 0;
    playerScore = 0;
    gameOver = false;
    $("#virusScore").html(virusScore);
    $("#playerScore").html(playerScore);

    $("div").delay(1000).fadeIn();
    myPlayer.delay(1000).fadeIn();
    $(".germ").delay(1000).fadeIn();

    $(".germ").delay(1500).data("checkforCollisions", true);
    initializePlayer();
    /*
    initializePlayer();
    intializeGerms();
    intializeshortcutKeys();
*/


    gameInterval = setInterval(updateGame, 10);

}



function myPlayerLost($whichGerm) {
    $("div").fadeOut();
    clearInterval(gameInterval);
    alert("Sad to say . . . you lost. Play again?");

    /*
    $(".germ").fadeOut();
    myPlayer.fadeOut();
    */
    reStartInterval= setInterval(reInitializeGame, 5000);
}



function myPlayerWon(){
    $("div").fadeOut();
    clearInterval(gameInterval);
    alert("You Won");

    /*
     $(".germ").fadeOut();
     myPlayer.fadeOut();
     */
    reStartInterval= setInterval(reInitializeGame, 2000);
}


var KEY = {
    UP: 38,
    DOWN: 40,
    LEFT: 37,
    RIGHT: 39,
    RED : 49,//1
    YELLOW : 50,//2
    ORANGE : 51,//3
    GREEN : 52,//4
    CYAN : 53,//5
    BLUE : 54//6
};

function setNewPlayerValues($whichSprite) {
    var mySpeed = 3;
    var myAmountToRotate = 3;
    var whichSprite = $whichSprite;


    switch (whichSprite.data("whichKey")) {
        case KEY.UP:
            whichSprite.data("speed", mySpeed);
            break;

        case KEY.DOWN:
            whichSprite.data("speed", -mySpeed);
            break;

        case KEY.RIGHT:
            whichSprite.data("amountToRotate", myAmountToRotate);
            break;

        case KEY.LEFT:
            whichSprite.data("amountToRotate", -myAmountToRotate);
            break;
        case KEY.RED:
            myPlayer.data("myColor", "red");
            myPlayer.attr("src", "img/05_player.png");
            break;
        case KEY.YELLOW:
            myPlayer.data("myColor", "yellow");
            myPlayer.attr("src", "img/04_player.png");
            break;
        case KEY.ORANGE:
            myPlayer.data("myColor", "orange");
            myPlayer.attr("src", "img/03_player.png");
            break;
        case KEY.GREEN:
            myPlayer.data("myColor", "green");
            myPlayer.attr("src", "img/02_player.png");
            break;
        case KEY.CYAN:
            myPlayer.data("myColor", "cyan");
            myPlayer.attr("src", "img/01_player.png");
            break;
        case KEY.BLUE:
            myPlayer.data("myColor", "blue");
            myPlayer.attr("src", "img/00_player.png");
            break;
    }
}





function animatePlayer() {
    faceTheCorrectDirection(myPlayer);
    moveTheCorrectDirection(myPlayer);
}

function faceTheCorrectDirection($whichSprite) {
    var whichSprite = $whichSprite;

    var currentRotation = whichSprite.data("currentRotation");

    currentRotation += whichSprite.data("amountToRotate");
    currentRotation = currentRotation % 360;
    whichSprite.data("currentRotation", currentRotation);

    var rotationText = "rotate(" + whichSprite.data("currentRotation") + "deg)";

    whichSprite.css({transform: rotationText});

    whichSprite.data("amountToRotate", 0);

}
function moveTheCorrectDirection($whichSprite) {
    var whichSprite = $whichSprite;

    var angle = whichSprite.data("currentRotation");
    angle = angle * Math.PI / 180;
    ax = Math.cos(angle) * whichSprite.data("speed");
    ay = Math.sin(angle) * whichSprite.data("speed");



    /*
    if (whichSprite.attr("class")) {
        ax = whichSprite.data("ax");
        ay = whichSprite.data("ay");

        var angle = whichSprite.data("currentRotation");
        angle = angle * Math.PI / 180;
        ax = Math.cos(angle) * whichSprite.data("speed");
        ay = Math.sin(angle) * whichSprite.data("speed");

    } else {

        var angle = whichSprite.data("currentRotation");
        angle = angle * Math.PI / 180;
        ax = Math.cos(angle) * whichSprite.data("speed");
        ay = Math.sin(angle) * whichSprite.data("speed");
    }

*/
    ax = Math.round(ax);
    ay = Math.round(ay);


    var x = parseInt(whichSprite.css("left"));
    x = Math.round(x);

    var y = parseInt(whichSprite.css("top"));
    y = Math.round(y);

    var bounce = -1;
//var myBottom = parseInt(myHeading.css('top-margin'));

    if (y > gameBorders.myBottom) {

        if (whichSprite.attr("class")) {
            y = gameBorders.myBottom - whichSprite.height();
            ay *= bounce;
        } else {
            y = gameBorders.myTop;

        }
    }
    else if (y < gameBorders.myTop) {
        if (whichSprite.attr("class")) {
            y = gameBorders.myTop + whichSprite.height();
            ay *= bounce;
        } else {
            y = gameBorders.myBottom;
        }

    }

   if (x > gameBorders.myRight) {
        if (whichSprite.attr("class")) {
            x = gameBorders.myRight - whichSprite.height();
            ax *= bounce;
        } else {
            x = gameBorders.myLeft;
        }

    }
    else if (x < gameBorders.myLeft) {
        if (whichSprite.attr("class")) {

            x = gameBorders.myLeft + whichSprite.width();
            ax *= bounce;

        } else {

            x = gameBorders.myRight;
        }

    }

    y += ay;
    x += ax;

    whichSprite.css({top: y,
        left: x});

    if (whichSprite.attr("class")) {
        var dx = (x + ax) - x;
        var dy = (y + ay) - y;

        var myCurrrentRotation = Math.atan2(dy, dx) * 180 / Math.PI;
        myCurrentRotation = Math.floor(myCurrrentRotation);

        whichSprite.data("currentRotation", myCurrrentRotation);
        whichSprite.data("ax", ax);
        whichSprite.data("ay", ay);
    }else{
        var checkForCollisiions = myPlayer.data("collided");
   console.log("checkForCollisions = "+ checkForCollisiions);
        if (!checkForCollisiions)
        {

   //         console.log("checking for collisions")
            $(".germ").each(function () {
                var thisIdText = $(this).attr("id");
                var otherSpriteToCheck = $("#" + thisIdText);
                if (otherSpriteToCheck.data("checkForCollisions"))
                {
                checkCollision(whichSprite, otherSpriteToCheck);
                }
           });
        }
 }


}






function checkCollision (whichSprite0, whichSprite1) {
myNum +=1;
    //console.log("myNum = "+ myNum);
    //console.log("inside checkCollison");
    var ball0={
            x : parseInt(whichSprite0.css("left")),
            y : parseInt(whichSprite0.css("top")),
            radius : whichSprite0.width()/2,
            mass : whichSprite0.data("mass"),
            vx : whichSprite0.data("ax"),
            vy : whichSprite0.data("ay")
    };


    var ball1={
               x : parseInt(whichSprite1.css("left")),
               y : parseInt(whichSprite1.css("top")),
               radius : whichSprite1.width()/2,
               mass : whichSprite1.data("mass"),
                vx : whichSprite1.data("ax"),
                vy : whichSprite1.data("ay")
    };

    var dx = ball1.x - ball0.x;
    var dy = ball1.y - ball0.y;
  //  console.log("dx = "+dx);
   // console.log("dy ="+dy);
        dist = Math.sqrt(dx * dx + dy * dy);
    //collision handling code here



    if (dist < ball0.radius + ball1.radius) {
        //calculate angle, sine, and cosine
        germCollidedWithPlayer(whichSprite1)

    }
}

function germCollidedWithPlayer($whichGerm){
    var whichGerm = $whichGerm;
    console.log("src = " + myPlayer.attr("src"));
    myPlayer.data("collided", true);
  //  alert("collided!")
    var myColor = myPlayer.data("myColor");
    var germColor = whichGerm.attr("id");

    if (myColor == germColor)

    {
        //myPlayer kills the germ
        playerScore += 1;
        $("#playerScore").html(playerScore);
        whichGerm.effect("explode",function(){
           // whichGerm.remove();
            whichGerm.data("checkForCollisions", false);
            myPlayer.data("collided", false);
            if (playerScore ==6){
         //if ($(".germ").length==0){

            return myPlayerWon();

         }

        })
    }else{
        //the germ kills myPlayer
        virusScore += 1;
        $("#virusScore").html(virusScore);
    // check to see if myPlayer lost
        var collisionLimit = myPlayer.data("collisionLimit");
        if (virusScore > collisionLimit){
            // myPlayer lost
            myPlayerLost(whichGerm);
        }else{
            //myPlayer explodes but the game isn't over
                myPlayer.data("numberOfCollisions",virusScore);
                myPlayer.effect("explode", function(){
                myPlayer.data("collided", false);
                myPlayer.fadeToggle(500, function(){
                });
            });
        }
   }
}

function GermMaker($whichListNumber){
    //<img class="germ" src="img/00_germ.png">
    this.germList = ["00","01", "02", "03", "04", "05"];
    this.attributeList = [];
    this.attributeList[0] = "id='blue' src='img/00_germ.png'";
    this.attributeList[1] = "id='cyan' src='img/01_germ.png'";
    this.attributeList[2] = "id='green' src='img/02_germ.png'";
    this.attributeList[3] = "id='orange' src='img/03_germ.png'";
    this.attributeList[4] = "id='yellow' src='img/04_germ.png'";
    this.attributeList[5] = "id='red' src='img/05_germ.png'";

    //this.attributeListNumber = Math.floor(Math.random() * 5);
    this.attributeListNumber = $whichListNumber;
    this.attributes = this.attributeList[this.attributeListNumber];

    this.newSprite = "<img class='germ'"+ this.attributes +" />";

   myPlayer.after(this.newSprite);

    //console.log(this.newSprite);


    this.top = randomizer(gameBorders.myTop, gameBorders.myBottom);
    this.left = randomizer(gameBorders.myLeft, gameBorders.myRight);

    this.idList=[$("#blue"), $("#cyan"), $("#green"), $("#orange"), $("#yellow"), $("#red")];
    this.whichId = this.idList[this.attributeListNumber];

    this.whichId.css({top:this.top,
    left:this.left}) ;

    this.whichId.data("amountToRotate", 0);
   // this.whichId.data("currentRotation", Math.floor(Math.random() * 360));
    this.whichId.data("currentRotation", randomizer(100, 360) * direction());
    this.whichId.data("ax", randomizer(1,5) * direction());
    this.whichId.data("ay", randomizer(1,5) * direction());
    var fastest = 5;
    var slowest = 1;
    var myOffset = (fastest - slowest) - 1;
    this.whichId.data("speed", Math.floor(Math.random() * myOffset) + slowest);
    this.whichId.data("rotationText", null);
    this.whichId.data("angle", 0);
    this.whichId.data("mass", 1);
    this.whichId.data("collided", false);
    this.whichId.data("checkForCollisions", true);



}

function direction(){
    var directionArray = [1,1,1,1,-1,-1,-1,-1,-1];
    var directionArrayIndex = Math.floor(Math.random() * (directionArray.length -1));

    var x =directionArray[directionArrayIndex];
    //console.log("x ="+x);
    return x;
}

randomizer = function (myLow, myHigh) {
    this.myLow = myLow;
    this.myHigh = myHigh;
    germId += 1;
    var offSet = (this.myHigh - this.myLow) - 1;
    var randomNumber = Math.floor(Math.random() * offSet) + this.myLow;
    return randomNumber;
};

function intializeGerms(){
    this.germList = [];
    for (i=0; i<6;i++){
        this.germList[i] = new GermMaker(i);
    }

}



function animateGerms(){
    $(".germ").each(function(index){
        var myIdText = $(this).attr("id");
        var whichSprite = $("#"+myIdText);
        var rotationListIndex  = Math.floor(Math.random() * germRotationList.length-1);
        var amountToRotate = germRotationList[rotationListIndex];
        whichSprite.data("amountToRotate", amountToRotate);
        whichSprite.data("collided", false);

        faceTheCorrectDirection(whichSprite);

        moveTheCorrectDirection(whichSprite);
  });
}

$(document).keydown(function (e) {
    myPlayer.data("animatePlayer", true);
    myPlayer.data("whichKey", (e.which));
});

$(document).keyup(function (e) {

    switch ((e.which)) {
        case KEY.UP:
            myPlayer.data("animatePlayer", false);
            break;

        case KEY.DOWN:
            myPlayer.data("animatePlayer", false);
            break;

        case KEY.RIGHT:
            myPlayer.data("whichKey", KEY.UP);
            myPlayer.data("amountToRotate", 0);
            break;

        case KEY.LEFT:
            myPlayer.data("whichKey", KEY.UP);
            myPlayer.data("amountToRotate", 0);
            break;
    }


});




//var newSprite = new GermMaker(0);
function rotate (x, y, sin, cos, reverse) {
    return {
        x: (reverse) ? (x * cos + y * sin) : (x * cos - y * sin),
        y: (reverse) ? (y * cos - x * sin) : (y * cos + x * sin)
    };
}
/*
function positionGame() {


    var myWidth = myWindowSize.width;
    var myMiddle = myWidth / 2;
    var halfBackGroundWidth = myPlayField.width() / 2;
    var backGroundLeft = myMiddle - halfBackGroundWidth;
    var backGroundTop = 25;

    myPlayField.offset({left: backGroundLeft, top: 25});

    myPlayer.offset({left: backGroundLeft + 50, top: backGroundTop + 50});
    player.x = backGroundLeft + 50;
    player.y = backGroundTop + 50;
}
*/












/*
 *
 * var top = parseInt($("#paddleA").css("top"));
 */

/*
 player.x += ax;
 player.y += ay;
 player.top = player.y;
 player.left = player.x;
 */
/*
 console.log("+++++++++++++++++++++");
 console.log("whichSprite top = " + whichSprite.css("top"));
 console.log("whichSprite left = " + whichSprite.css("left"));
 console.log("offset = " + offset);
 console.log("x = " + x);
 console.log("y = " + y);
 whichSprite.offset({top: x, left:y});

 myPlayer.css({top: player.top,
 left: player.left});

 whichSprite.css({top: y,
 left: x});

 */


function getWindowSize() {
    var wdth = 0;
    var hth = 0;
    if (!window.innerWidth) {
        wdth = (document.documentElement.clientWidth ?
            document.documentElement.clientWidth :
            document.body.clientWidth
            );
        //;

        hth = (document.documentElement.clientHeight ?
            document.documentElement.clientWidth :
            document.body.clientHeight);
    }
    else {
        wdth = window.innerWidth;
        hth = window.innerHeight;
    }

    return {width: wdth, height: hth};

}

