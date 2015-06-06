
function totalPanelWidth(){
	/*this function calculates and returns the total panel width of visible panels*/
	
	//console.log("inside totalPanelWidth");
	var total_w = 0;
	$("div.mssPanel:not(.invisible)").each(function(){
		
		var w = $(this).width();
		var panel_id = $(this).attr("id");
		//console.log("panel " + panel_id + ": " + w);
		total_w += w;

	});
	
	//console.log("Total width of visible panels: " + total_w);
	return total_w;
}



$.fn.dropdownButtonClick = function() {
    return this.click(function(e){
        e.stopPropagation();
		$(".dropdownButton").not(this).next(".dropdown").css('visibility', 'hidden');
		
		$(this).find("img").toggleClass("invisible");
		
		var visibility = $(this).next('ul').css('visibility');
		if ( visibility === 'hidden'){
			$(this).next('ul').css('visibility', 'visible');
		}
		else{
			$(this).next('ul').css('visibility', 'hidden');
		}
	
		$('html').click(function (e) {
			//e.stopPropagation();
			var container = $(".dropdown");

			//check if the clicked area is dropDown or not
			if (container.has(e.target).length === 0) {
				$(".dropdown").css('visibility', 'hidden');
			}
		});
    });
};

$.fn.changePanelVisibility = function(x,y) {
	/*param x and y are the coordinates where the panel should be moved to*/
	$(this).toggleClass("invisible");
	/*
	console.log("changePanelVisibility plugin:");
	console.log("param x: " + x);
	console.log("param x: " + !isNaN(x));
	console.log("param y: " + y);
	console.log("param x: " + !isNaN(y));
	*/
	if(!(x===undefined || y===undefined)){
	
		if(!isNaN(x) || x.substr(-2) === "em"){
			$(this).css({"left":x});
			}
		if(!isNaN(y) || y.substr(-2) === "em"){
			$(this).css({"top":y});
		}
	}
}

$.fn.panelActionClick = function() {
    return this.click(function(){
			var datapanelid = $(this).attr("data-panelid");
			
			if(datapanelid === "linenumbers"){
				$(".linenumber").toggleClass("invisible");
			}
			else{
					
				$("#"+datapanelid).each(function(){
				
					var y = $(this).css("top");
					var x = $(this).css("left");
					
					console.log("in panelActionClick plugin:");
					console.log("value var x: " + x);
					console.log("value var y: " + y);
					
					if(x === "auto"){
						x = totalPanelWidth();
					}
					
					$(this).changePanelVisibility(x, y);
					$(this).appendTo("#mssArea");
					
				});		
					
				workspaceResize();
			}
			
			$("*[data-panelid='"+datapanelid+"']").toggleOnOff();
		});
	};
	
$.fn.panelActionHover = function() {
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
	
$.fn.mssPanel = function() {
    return this.each(function(){
		var $that = $(this);
		$that.mousedown(function(){
			$(".activePanel").each(function(){
				$(this).css({"z-index":2}).removeClass("activePanel");
			});
			
			$that.addClass("activePanel").css({"z-index":5});
			$that.appendTo("#mssArea");
		});
		
		$that.hover(function(){
			$that.addClass("highlight");
			var p = $that.attr("id");
		
			$(".dropdown li[data-panelid='"+p+"']").addClass("highlight");
		
		}, function(){
			$that.removeClass("highlight");
			var p = $(this).attr("id");
			$(".dropdown li[data-panelid='"+p+"']").removeClass("highlight");
		});
	});	
};

$.fn.imgPanel = function() {
    return this.each(function(){
	
		var $that = $(this);
		var imageId = $that.attr("id");
		
		$that.mousedown(function(){
			$(".activePanel").each(function(){
				$(this).css({"z-index":2}).removeClass("activePanel");
			});
			$that.addClass("activePanel").css({"z-index":5});
			$that.appendTo("#mssArea");
		});
		
		$that.hover(function(){
			$("img[data-img-id='" + imageId +"']").addClass("highlight");
			$(this).addClass("highlight");
		
		}, function(){
			$("img[data-img-id='" + imageId +"']").removeClass("highlight");
			$(this).removeClass("highlight");
		});
		
	});	
};
	

/********IMAGE PANEL REWRITE wit JQUERY*********/

 
$.fn.toggleOnOff = function() {
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
 
/*image panel functionality*/


$.fn.hoverPopup = function() {
	
	return this.hover(function(e){
		$("<div id='showNote'>empty note</div>").appendTo("body");
		var noteContent = $(this).find("div.note, div.corr, span.altRdg").html();
		
		$("#showNote").html(noteContent);
		$("#showNote").css({
			"position": "absolute",
			"top": e.pageY + 5,
			"left": e.pageX + 5,
		}).show();
	
	}, function(e){
		$("#showNote").hide();
	});
};


function workspaceResize(){

            var mssAreaWidth = $('#mssArea').width();
            
            var w = totalPanelWidth();
            
            var windowWidth = $(window).width();
            
            if( windowWidth > w){
                $('#mssArea').width(windowWidth);
            }
            else{
                $('#mssArea').width(w+100);
            }
			
			/*height of workspace*/
			var panelHeight = 0;
			$(".panel").each(function(idx, element){
				var h = $(element).height();
				if(panelHeight < h){
					panelHeight = h;
				}
			});
			$("#mssArea").css({"height":panelHeight+100});
}

$.fn.switchTopMenu = function(){
	/*switches the top menu from wide screen view to three-line menu button*/
	var windowWidth = $(window).width();
            
    if( windowWidth < 900){
          $(".largeScreenTopMenu").hide();
		  $(".smallScreenDropdown").show();
		 
       }
       else{
           $(".largeScreenTopMenu").show();
			$(".smallScreenDropdown").hide();
           }

}


$.fn.match_lines = function() {
		this.click(function(){
			var line_id = $(this).attr("data-line-id");
			//add or remove attr match_hi
			$("."+line_id).toggleClass("match_hi");
		});
};


$.fn.audio_match = function() {
		/**app to add **/
		this.click(function(){
			if($(this).hasClass("match_hi")){
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

$.fn.match_app = function() {
		this.click(function(){
			var app = $(this).attr("data-app-id");
			//add or remove attr match_hi
			$("."+app).toggleClass("match_hi");
			
		});
};

$.fn.zoomPan = function() {
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



$.fn.imgLink = function() {
		this.each(function(){
			$(this).click(function(e){
				
				var imgId = $(this).attr("data-img-id");
				$("#"+imgId).appendTo("#mssArea");
				
				$("#"+imgId).css({
					"position": "absolute",
					"top": e.pageY,
					"left": e.pageX,
					"z-index": "5"
					}).toggleClass("invisible").addClass("activePanel");
				
				
			});
			
			$(this).hover(function(){
				var panelId = $(this).attr("data-img-id");
				$(".imgPanel[id='" + panelId + "']").addClass("highlight");
			},function(){
				var panelId = $(this).attr("data-img-id");
				$(".imgPanel[id='" + panelId + "']").removeClass("highlight");
			
			});
				
		});
		
};


$(document).ready(function() {  
	/*initial setup */

	var panelPos = 0;
	
	var bannerHeight = "8em";
	
	/*initial setup show biblio panel*/
	console.log("Show bibliographic panel: " + DISPLAYBIBINFO);
	
	if(DISPLAYBIBINFO){
			$("#bibPanel").changePanelVisibility(panelPos,bannerHeight);
			$("nav *[data-panelid='bibPanel']").toggleOnOff();
			panelPos += $("#bibPanel").width();
		}
		
	/*open the witness/version panels*/
	
	$("#witnessList li").each(function(idx){
		var wit = $(this).attr("data-panelid");
		
		/*The INITIALVERSIONS global can be set in settings.xsl*/
		if(idx < INITIALVERSIONS){
			$("#"+wit).changePanelVisibility(panelPos,bannerHeight);
			$("*[data-panelid='"+wit+"']").toggleOnOff();
			panelPos += $("#"+wit).width();
		}	
	});
	
	/*initial setup show critical intro panel*/
	
	if(DISPLAYCRITINFO){
			$("#critPanel").changePanelVisibility(panelPos,bannerHeight);
			$("nav *[data-panelid='critPanel']").toggleOnOff();
			panelPos += $("#critPanel").width();
		}
	
	/*initial setup show notes panel*/
	
	if(DISPLAYNOTESPANEL){
			$("#notesPanel").changePanelVisibility(panelPos,bannerHeight);
			$("nav *[data-panelid='notesPanel']").toggleOnOff();
			panelPos += $("#notesPanel").width();
		}
		
	console.log("Display line numbers: " + DISPLAYLINENUMBERS);
	/*initial setup show notes panel*/
	if(DISPLAYLINENUMBERS){
			$(".linenumber").toggleClass("invisible");
			$("nav *[data-panelid='linenumbers']").toggleOnOff();
		}
	
			
	/*top menu*/
	$(window).switchTopMenu();
	
	$(window).resize(function(){
        workspaceResize();
		$(this).switchTopMenu();
    });
	
	
	workspaceResize();
	
	//initialises the dropdown functionality
	$(".dropdownButton").dropdownButtonClick();
	
	$("li[data-panelid]").panelActionClick();
	$("li[data-panelid!='linenumbers']").panelActionHover();
	
	/*create popup for note, choice, etc.*/
	$("div.noteicon, div.choice, div.rdgGrp").hoverPopup();
	
	
	/*close panel via X sign */
	$(".closePanel").click(function(){
		var w = $(this).closest(".panel").attr("id");
		
		$(this).closest(".panel").addClass("invisible");
		
		$("*[data-panelid='"+w+"']").toggleOnOff();
		
		workspaceResize();
		
	});
	
	/*adds the match line or apparatus highlighting*/
	$(".apparatus").match_app();
	$(".apparatus").audio_match();

    $("li[data-panelid='notesPanel']").click(function(){

		$("#mssArea .noteicon").toggle();

	});
	
	$( ".panel" ).draggable({
		containment: "parent",
		zIndex: 6
	}).resizable(
	{helper: "ui-resizable-helper"}
	);
	
	$(".imgPanel").zoomPan();
	$(".mssPanel").mssPanel();
	$(".imgPanel").imgPanel();
	$(".imageLink").imgLink();
	

});


