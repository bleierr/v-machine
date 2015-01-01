
function showWit(panel, wit){
	$("#"+panel+" ."+wit+".reading").show();
}

function hideWit(panel, wit){
	$("#"+panel+" ."+wit+".reading").hide();
}







$(document).ready(function(){
	
	//alert(witnesses);
	$(".reading").hide();
	
	showWit("panel1","w");
	showWit("panel2","w");	
	
	$(".wit-button").click(function(){
		var panel = $(this).closest(".mssPanel").attr("id");
		
		var wit = $(this).attr("value");
		_.each(witnesses, function(k, v){
			if(k == wit){
				showWit(panel, k);
				}
			else{
				hideWit(panel, k);
			}
		
		});
	});
	
	_.each(witnesses, function(k, v){
		console.log(k +' '+ v);		
	});
	
	$(".line").click(function(){
		var classes = $(this).attr("class").split(" ");
		var lineID = _.find(classes, function(c){ 
			if(c.slice(0,5) == "lined")
				return true;
			else
				return false;
		});
		$("."+lineID).toggleClass("highlighted");
		
	});
	


});