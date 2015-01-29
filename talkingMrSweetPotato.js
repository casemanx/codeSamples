


//alert("javascript loaded");

my = {};
my.main = document.getElementById("main");
my.allText = document.getElementById("allText");
my.txt1 = document.getElementById("txt1");
my.txt2 = document.getElementById("txt2");
my.txt3 = document.getElementById("txt3");
my.txt4 = document.getElementById("txt4");
my.txt5 = document.getElementById("txt5");
//my.sweetPotatoHead = document.getElementById("sweetPotatoHead");
my.ph = document.getElementById("ph");
my.allFields = document.getElementById("allFields");
my.index_00 = document.getElementById("index_00");
my.index_01 = document.getElementById("index_01");
my.index_02 = document.getElementById("index_02");
my.index_03 = document.getElementById("index_03");
//my.index_04 = document.getElementById("index_04");
my.moreInfo = document.getElementById("moreInfo");
my.recipe = document.getElementById("recipe");
//my.bubble = document.getElementById("bubble");
var repeat = 0
var v = document.getElementsByTagName('video')[0]
v.pause();
var t = document.getElementById('time');



(function(){
    v.addEventListener('timeupdate',function(event){
//      alert("function")
// var myCurrentTime = parseInt(v.currentTime) ;
//        console.log("=======");
    },false);
})();






window.onload=function()
{
//alert("windows loaded");

   animate();


};


function startTalking(){
 //  alert("onStart");
    v.play()

}



//alert("javascript loaded");

var t1 = new TimelineMax();

function animate()
{
    var myElements;
    t1.to(my.ph, 1, {x:-130});



     myElements = [my.txt1];
//Mr Sweet Potato Head Says
    t1.appendMultiple(
        [
            TweenLite.to(myElements[0], 1, {alpha:1, onStart:startTalking})
            ,TweenLite.to(myElements[0], 1, {alpha:0, delay:.75})
        ]
        ,0, "sequence",0
    );

// . . of all the fields
    myElements = [my.txt2, my.index_00];
    t1.appendMultiple(
        [
            TweenLite.to(myElements, 1, {alpha:.75})
            ,TweenLite.to(myElements, 1, {alpha:0, delay:1})
        ]
        ,0, "sequence",0
    );


// . . we sow
    myElements = [my.txt3, my.index_01];
    t1.appendMultiple(
        [
            TweenLite.to(myElements, 1, {alpha:1})
            ,TweenLite.to(myElements, 1, {alpha:0, delay:2})
        ]
        ,0, "sequence",0
    );

// . . and reap
    myElements = [my.txt4, my.index_02];
    t1.appendMultiple(
        [
            TweenLite.to(myElements, 1, {alpha:1})
            ,TweenLite.to(myElements, 1, {alpha:0, delay:2})
        ]
        ,0, "sequence",0
    );


   //Sweet Potatoes are the most nutritious
    myElements = [my.txt5, my.index_03]
    t1.appendMultiple(
        [
            TweenLite.to(myElements, 1, {alpha:1})
            ,TweenLite.to(myElements[1], 1, {alpha:0, delay:2})

        ]
        ,0, "sequence",0
    );

    myElements = [my.recipe];
    t1.appendMultiple(
        [
            TweenLite.to(myElements[0], 1, {alpha:1, delay:1, onStart:resetVideo})
        ]
        ,0, "sequence",0
    );

//t1.restart();

    //t1.to(my.ph, 1, {x:-130});

};
function resetVideo(){
    v.pause();
    v.currentTime=0;
    repeat += 1;
    if (repeat< 3){

        myElements = [my.txt5, my.recipe];
        t1.appendMultiple(
            [
                TweenLite.to(myElements, 1, {alpha:0, delay:2, onComplete:resetVideo})
            ]
            ,0, "sequence",0
        );

        animate();
    }else{

    }

}
