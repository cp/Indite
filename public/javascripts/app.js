$(function(){
  ws = new WebSocket("ws://localhost:8080");
  
  ws.onmessage = function(evt) {
      $('#content').html(evt.data);  
  };
  
  	$("#content").keydown(function(e) {
    if($("#content").html().length > 0){
      setTimeout(function(){ws.send($("#content").html())},0);
    }
  });
  
});