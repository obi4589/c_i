$(document).ready(function(){
  $("address").each(function(){                         
    var embed ="<iframe width='205' height='183' frameborder='0' scrolling='no'  marginheight='0' marginwidth='0'   src='https://maps.google.com/maps?&amp;q="+ encodeURIComponent( $(this).text() ) +"&amp;output=embed'></iframe>";
                                $(this).html(embed);
                             
   });
});