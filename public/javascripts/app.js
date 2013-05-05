$(function(){
  ws = new WebSocket("ws://localhost:8080");
  
  ws.onmessage = function(evt) {
      $('#content').html(evt.data);  
  };
  
  $("#content").keyup(function(e) {
    if($("#content").html().length > 0){
      ws.send($("#content").html());
    }
  });
  
});