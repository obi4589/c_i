$(document).ready(function() {
	
	$("#share_frame2").mouseenter(function() {
		 $("#share_frame1").show();
	});
	
	
	$("#share_frame2").mouseleave(function() {
		 $("#share_frame1").hide();
	});
	
	$("#share_frame1").mouseenter(function() {
		 $("#share_frame1").show();
	});
	
	$("#share_frame1").mouseleave(function() {
		 $("#share_frame1").hide();
	});
	
});