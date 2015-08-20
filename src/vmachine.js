/**
	* @license vmachine.js for VM 5.0
	* Updated: Aug 10 2015 by roman bleier
	* Adds JS functionality to VM 5.0
	* Copyright (c) 2015 roman bleier
	* Released under the MIT license
	* Permission is hereby granted, free of charge, to any person obtaining
	* a copy of this software and associated documentation files (the
	* "Software"), to deal in the Software without restriction, including
	* without limitation the rights to use, copy, modify, merge, publish,
	* distribute, sublicense, and/or sell copies of the Software, and to
	* permit persons to whom the Software is furnished to do so, subject to
	* the following conditions:

	* The above copyright notice and this permission notice shall be
	* included in all copies or substantial portions of the Software.

	* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	* LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
	* OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
	* WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	**/

function moveToFront($that){
	/*function to change the stack order of a JQuery panel element and adds it to the front of all visible panels*/
	$(".activePanel").each(function(){
				$(this).css({"z-index":2}).removeClass("activePanel");
			});			
		$that.addClass("activePanel").css({"z-index":5, "opacity":1});
		$that.nextAll().insertBefore($that);
}
	
function totalPanelWidth(){
	/*function to calculate and return the total panel width of visible panels*/
	var totalWidth = 0;
	$("div.panel:not(.noDisplay)").each(function(){
		var wid = $(this).width();
		totalWidth += wid;
	});
	return totalWidth;
}

function PanelInPosXY(selector, top, left){
	/** @PanelInPosXY function to find if a panel/element is in the location left/top 
	*param selector: JQuery selector ( for instance to select all panels, or all visibal panels)
	*param left: the left coordinates of the panel/element 
	*param top: the top coordinates of the panel/element
	*/
	panelPresent = false;
	$(selector).each(function(){
			var pos = $(this).position();
			if(pos.left == left && pos.top == top){
					panelPresent = true;
			}
			
	});
	return panelPresent;
}

function workspaceResize(){
	/** @workspaceResize resizes the workspace depending on how many panels are visible, 
	* if panel is opened the workspace becomes larger, 
	* if a panel is closed it becomes smaller
	*/
            var mssAreaWidth = $('#mssArea').width();
            var panelsWidth = totalPanelWidth();
			var windowWidth = $(window).width();
            if( windowWidth > panelsWidth){
                $('#mssArea').width(windowWidth);
				mssAreaWidth = windowWidth;
            }
            else{
                $('#mssArea').width(panelsWidth + 100);
				mssAreaWidth = panelsWidth + 100;
            }
			
			/*moves panel that is outside of workspace into workspace*/
			$("div.panel:not(.noDisplay)").each(function(idx, element){
				$ele = $(element);
				var l = $ele.position().left;
				var t = $ele.position().top;
				var w = $ele.width();

				if( (l + w) > mssAreaWidth ){
					$ele.offset({top:t, left:mssAreaWidth-w});
				}
			});
			
			/* correct height of workspace*/
			var panelHeight = 0;
			$(".panel").each(function(idx, element){
				var h = $(element).height();
				if(panelHeight < h){
					panelHeight = h;
				}
			});
			$("#mssArea").css({"height":panelHeight+100});
}

/***** Functionality of dropdown menu and top menu *****/

$.fn.toggleOnOffButton = function() {
	/*plugin toggles between ON and OFF status of a button of top menu and dropdown*/
	return $(this).each(function(){
    var b = $(this).find("button");
		var content = b.html();
		
		if (content === "ON"){
		    b.html("OFF");
		}
		if (content === "OFF"){
		    b.html("ON");
		}
		b.toggleClass("buttonPressed");
		});
	}

$.fn.dropdownButtonClick = function() {
	/*plugin to add a click event to a dropdown button
	on click the following list with class 'dropdown will be shown
	*/
    return this.click(function(e){
        e.stopPropagation();
		/* change visibility of the dropdown list, 
		statement 'ul#witnessList.notVisible li{visibility: hidden;}' in css necessary 
		*/
		$(".dropdownButton").next(".dropdown").toggleClass('notVisible');
		/* change visibility of dropdown if click anywhere on the web page */
		$('html').click(function (e) {
			var container = $(".dropdown");
			//check if the clicked area is dropDown or not
			if (container.has(e.target).length === 0) {
				$(".dropdown").addClass('notVisible');
			}
		});
    });
};

$.fn.linenumberOnOff = function() {
	/*plugin to add a click event to linenumberOnOff button
	on click the line numbers in the panels become invisible
	*/
    return this.click(function(){
		$(".linenumber").toggleClass("noDisplay");
		$("#linenumberOnOff").toggleOnOffButton();
	});
}

$.fn.panelButtonClick = function() {
    return this.click(function(){
			var dataPanelId = $(this).attr("data-panelid");
			
			if(dataPanelId === "notesPanel"){
				//toggle inline note icons in panels
				$("#mssArea .noteicon").toggle();
			}
			
			$("#"+dataPanelId).each(function(){
					var top = $(this).css("top");
					var left = $(this).css("left");
					if(left === "-1px" || top === "-1px"){
						//if no panel is at default coordinate
						if(top == "-1px"){
							top = $("#mainBanner").height();
						}
						left = 0;
						//check if there is already a panel in this location
						while(PanelInPosXY("div.panel:not(.noDisplay)", top, left)){
							top += 20;
							left += 50;
						}
					}
					$(this).changePanelVisibility(top, left);
					moveToFront($(this));
				});		
				workspaceResize();
		$("*[data-panelid='"+dataPanelId+"']").toggleOnOffButton();
			
	});
};
	
$.fn.panelButtonHover = function() {
    return this.hover(function(){
		/*mouse enter event*/
		var p = $(this).attr("data-panelid");
		$(this).addClass("highlight");
		$("#"+p).addClass("highlight");
	}, function(){
		/*mouse leave event*/
		var p = $(this).attr("data-panelid");
		
		$(this).removeClass("highlight");
		$("#"+p).removeClass("highlight");
		
	});	
};

/***** END Functionality of dropdown menu and top menu *****/

/***** Functionality and visibility of Witness, Biblio, and Note panels *****/

$.fn.changePanelVisibility = function(top,left) {
	/* plugin to change the visibility of a panel and move it to different location
	param top and left are the coordinates where the panel should be moved to*/
	$(this).toggleClass("noDisplay");
	
	if( top === "-1px" || top === -1){
		top = $("#mainBanner").height();
	}
	else if( left === "-1px" || left === -1 ){
		left = 0;
	
	}
	
	if(!(top===undefined || left===undefined)){
	
		if($.type(top) === "string"){
			if((top.substr(-2) === "em") || (top.substr(-2) === "px")){
			top = top.slice(0,-2)
			}
		}
		if($.type(left) === "string"){
			if((left.substr(-2) === "em") || (left.substr(-2) === "px")){
				left = left.slice(0,-2)
			}
		}
		if(!isNaN(top) && !isNaN(left)){
			$(this).css({"left":left});
			$(this).css({"top":top});
			}
	}
}

$.fn.panelClick = function() {
	/* plugin to add a mousedown event to manuscript panels
	brings the panel to front
	*/
    return this.mousedown(function(){
			moveToFront($(this));
		});
};

$.fn.panelHover = function() {
	/* plugin to add a hover event to manuscript panels
	on hover the class 'highlight' is added or removed
	*/
    return this.hover(function(){
			$(this).addClass("highlight");
			var p = $(this).attr("id");
			$(".dropdown li[data-panelid='"+p+"']").addClass("highlight");
		}, function(){
			$(this).removeClass("highlight");
			var p = $(this).attr("id");
			$(".dropdown li[data-panelid='"+p+"']").removeClass("highlight");
	});
};

$.fn.closePanelClick = function() {
	/* plugin to add a click event to the closing button ('X') of panels 
	after a panel is closed the workspace has to be resized
	*/
    return this.click(function(){
		var w = $(this).closest(".panel").attr("id");
		$(this).closest(".panel").addClass("noDisplay");
		$("*[data-panelid='"+w+"']").toggleOnOffButton();
		workspaceResize();
	});
};

/***** END Functionality and visibility of Witness, Biblio, and Note panels *****/

/***** Functionality related to image panels *****/

$.fn.zoomPan = function() {
	/* plugin to use JQuery panzoom library for the image viewer
	https://github.com/timmywil/jquery.panzoom
	*/
		this.each(function(){
			var imgId = $(this).attr("id");
			var $section = $("div#" + imgId + ".imgPanel");
            $section.find('.panzoom').panzoom({
            $zoomIn: $section.find(".zoom-in"),
            $zoomOut: $section.find(".zoom-out"),
            $zoomRange: $section.find(".zoom-range")
		});
});
};

$.fn.imgLinkClick = function() {
	/* plugin to add a click event to imgLinks (icons that open the image viewer on click) */
		this.click(function(e){
				var imgId = $(this).attr("data-img-id");
				$("#"+imgId).appendTo("#mssArea");
				$("#"+imgId).css({
					"position": "absolute",
					"top": e.pageY,
					"left": e.pageX,
					}).toggleClass("noDisplay").addClass("activePanel");
				//move the image panel to the front of all visible panels
				moveToFront($("#"+imgId))
			});
};
$.fn.imgLinkHover = function() {
	/* plugin to add a hover event to imgLinks (icons that open the image viewer on click) */
		this.hover(function(){
			/* current hover event add class 'highlight' on hover*/
				$(this).addClass("highlight");
				var panelId = $(this).attr("data-img-id");
				$(".imgPanel[id='" + panelId + "']").addClass("highlight");
			},function(){
			/* on hover out remove 'highlight' class*/
				$(this).removeClass("highlight");
				var panelId = $(this).attr("data-img-id");
				$(".imgPanel[id='" + panelId + "']").removeClass("highlight");
			});		
};
$.fn.imgPanelMousedown = function() {
	/* plugin to add a mousedown event to image panels */
    return this.mousedown(function(){
			moveToFront($(this));
	});	
};
$.fn.imgPanelHover = function() {
	/* plugin to add a hover event to the image panels*/
    return this.hover(function(){
			var imageId = $(this).attr("id");
			$("img[data-img-id='" + imageId +"']").addClass("highlight");
			$(this).addClass("highlight");
		}, function(){
			var imageId = $(this).attr("id");
			$("img[data-img-id='" + imageId +"']").removeClass("highlight");
			$(this).removeClass("highlight");
		});
};
/***** END Functionality related to image panels *****/

/***** Functionality popup notes and apparatus/line matching *****/

$.fn.hoverPopupNote = function() {
	/* plugin to add a hover effect and popup note */
	return this.hover(function(e){
		$("<div id='showNote'>empty note</div>").appendTo("body");
		//the location of the note content has to be added to the find method
		var noteContent = $(this).find("div.note, div.corr, span.altRdg").html();
		
		$showNote = $("#showNote");
		
		$showNote.html(noteContent);
		$showNote.css({
			"position": "absolute",
			"top": e.pageY + 5,
			"left": e.pageX + 5,
		}).show();
		
		console.log("Note height" + $showNote.height() );
		console.log("Innerdocument height" + window.innerHeight );
		console.log("PageY" + e.pageY );
		
		if((e.pageY + $showNote.height()) > window.innerHeight){
			$showNote.css({
				"left": "auto",
				"right": window.innerWidth - e.pageX
			});
		}
		
		
	}, function(e){
		/* on hover out hide the note */
		$("#showNote").hide();
	});
};

$.fn.matchAppHover = function() {
	/* plugin that adds a apparatus matching functionality */
		this.hover(function(){
			var app = $(this).attr("data-app-id");
			$("."+app).addClass("matchAppHi");
		},function(){
			var app = $(this).attr("data-app-id");
			$("."+app).removeClass("matchAppHi");
		});
};
$.fn.matchAppClick = function() {
	/* plugin that adds a line matching functionality */
		this.click(function(){
			var app = $(this).attr("data-app-id");
			$("."+app).toggleClass("matchAppHiClicked");
		});
};
$.fn.matchLineHover = function() {
	/* plugin that adds a apparatus matching functionality */
		this.hover(function(){
			var line = $(this).attr("data-line-id");
			$("."+line).parent().addClass("matchLineHi");
		},function(){
			var line = $(this).attr("data-line-id");
			$("."+line).parent().removeClass("matchLineHi");
		});
};
$.fn.matchLineClick = function() {
	/* plugin that adds a line matching functionality */
		this.click(function(){
			var line = $(this).attr("data-line-id");
			$("."+line).parent().toggleClass("matchLineHiClicked");
		});
};
/***** END Functionality popup notes and apparatus/line matching *****/

$.fn.audioMatch = function() {
		/**app to add **/
		this.click(function(){
			if($(this).hasClass("matchHi")){
				var timeStart = $(this).attr("data-timeline-start");
				var timeInterval = $(this).attr("data-timeline-interval");
				
				$(this).closest(".mssPanel").find("audio").each(function(){
					var $audio = $(this);
					$audio.prop("currentTime",timeStart);
					$audio.trigger('play');
					setTimeout(function(){$audio.trigger('pause')}, 1000 * timeInterval);
					
				});
			}
		});
};

/***** Initial setup of panels  *****/

function bibPanel(){
	var keyword = "bibPanel";
	var panelPos = totalPanelWidth();
	if(INITIAL_DISPLAY_BIB_PANEL){
		//bibPanel visible, constant INITIAL_DISPLAY_BIB_PANEL can be found in settings.xsl
		$("#"+keyword).changePanelVisibility("-1px", panelPos);
		$("nav *[data-panelid='"+ keyword +"']").toggleOnOffButton();
	}	
	$("#"+keyword).panelClick();
	$("#"+keyword).panelHover();
}
function notesPanel(){
	var keyword = "notesPanel";
	var panelPos = totalPanelWidth();
	
	if(INITIAL_DISPLAY_NOTES_PANEL){
		//notesPanel visible, constant INITIAL_DISPLAY_NOTES_PANEL can be found in settings.xsl
		$("#"+keyword).changePanelVisibility("-1px", panelPos);
		$("nav *[data-panelid='"+ keyword +"']").toggleOnOffButton();
		$("#mssArea .noteicon").toggle();
	}	
	$("#"+keyword).panelClick();
	$("#"+keyword).panelHover();
}
function critPanel(){
	var keyword = "critPanel";
	var panelPos = totalPanelWidth();
	if(INITIAL_DISPLAY_CRIT_PANEL){
		//critPanel visible, constant INITIAL_DISPLAY_CRIT_PANEL can be found in settings.xsl
		$("#"+keyword).changePanelVisibility("-1px", panelPos);
		$("nav *[data-panelid='"+ keyword +"']").toggleOnOffButton();
	}	
	$("#"+keyword).panelClick();
	$("#"+keyword).panelHover();
}
function linenumber(){
	keyword = "linenumber";
	if(INITIAL_DISPLAY_LINENUMBERS){
		//linenumbers visible, constant INITIAL_DISPLAY_LINENUMBERS can be found in settings.xsl
		$(".linenumber").toggleClass("noDisplay");
		$("nav li#linenumberOnOff").toggleOnOffButton();
	}
}

function descendentsHaveClass(ele, className){
	var found = false
	
	$(ele).find("*").each(function(){
		if($(this).hasClass(className)){
			found = true
		}
	});
	
	
	return found
}



function mssPanels(){
	//initial setup
	//open the witness/version panels
	var keyword = "versions";
	
	//by default the vmachine.xsl displays all versions in each panel, not relevant versions have to be hidden
	$(".mssPanel").each(function(idx){
		var mssId = $(this).attr("id");
		
		$(this).find(".mssContent *").filter(function(idx, ele){
			var hide = true;
			if( descendentsHaveClass(ele, mssId) || ($(ele).hasClass(mssId)) ){
				hide = false;
			}
			console.log(ele.tagName);
			if( $(ele).hasClass("linenumber") ){
				hide = false;
			}
			if( $(ele).hasClass("del") || $(ele).hasClass("add") || $(ele).hasClass("corr") || $(ele).hasClass("reg") ){
				hide = false;
			}
			if( $(ele).hasClass("linebreak") ){
				hide = false;
			}
			return hide;
		
		}).hide();
		
	
	});
	
	//manuscript panels visible, constant INITIAL_DISPLAY_NUM_VERSIONS can be found in settings.xsl
	var versions = INITIAL_DISPLAY_NUM_VERSIONS;
	$("#witnessList li").each(function(idx){
				var panelPos = totalPanelWidth();
				var wit = $(this).attr("data-panelid");
				if(idx < versions){
					$("#"+wit).changePanelVisibility("-1px", panelPos);
					$("*[data-panelid='"+wit+"']").toggleOnOffButton();
				}	
			});
	//add functionality to manuscript panels
	$(".mssPanel").panelClick();
	$(".mssPanel").panelHover();
}
/***** END initial setup of panels  *****/

$(document).ready(function() {  
	
	/*****initial panel and visibility setup *****/
	bibPanel();
	mssPanels();
	notesPanel();
	critPanel();
	linenumber();

	//after the visibility of all necessary panels is changed the workspace has to be resized to fit panels
	workspaceResize();
	
	/*****END initial panel and visibility setup *****/
	
	/***** activate all plugins *****/
	//close panel via X sign 
	$(".closePanel").closePanelClick();
	
	//dropdown functionality
	$(".dropdownButton").dropdownButtonClick();
	
	//click and hover event for panel buttons
	$("li[data-panelid]").panelButtonClick();
	$("li[data-panelid]").panelButtonHover();
	
	//click event to display and hide linen numbers
	$("#linenumberOnOff").linenumberOnOff();
	
	//create popup for note, choice, etc.
	$("div.noteicon, div.choice, div.rdgGrp").hoverPopupNote();
	
	//adds match line/apparatus highlighting plugin
	$(".apparatus").matchAppHover();
	$(".apparatus").matchAppClick();
	//adds match audio with transcription plugin
	$(".apparatus").audioMatch();
	
	$(".linenumber").matchLineClick();
	$(".linenumber").matchLineHover();
	
	/**add draggable and resizeable to all panels (img + mss)*/
	$( ".panel" ).draggable({
		containment: "parent",
		zIndex: 6
	}).resizable(
	{helper: "ui-resizable-helper"}
	);
		
	/**add functionality to image panels*/
	$(".imgPanel").zoomPan();
	$(".imgPanel").imgPanelHover();
	$(".imgPanel").imgPanelMousedown();
	$(".imageLink").imgLinkClick();
	$(".imageLink").imgLinkHover();
	
});
