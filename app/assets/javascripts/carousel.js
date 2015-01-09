$(document).ready(function() {
 
  $(".owl-carousel").owlCarousel({
 
      autoPlay: 3500,
      dragBeforeAnimFinish: false,
      mouseDrag: false,
      touchDrag: false,
      pagination: false,
      navigation : false, // Show next and prev buttons
      singleItem:true
 
      // "singleItem:true" is a shortcut for:
      // items : 1, 
      // itemsDesktop : false,
      // itemsDesktopSmall : false,
      // itemsTablet: false,
      // itemsMobile : false
 
  });
 
});