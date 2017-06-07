function updateDisplay(text, callback) {
    $('#board').html(text);
    setTimeout(function() {
        callback();
    }, 200);
}

$(document).ready(function () {
    var uri = 'ws://localhost:8000/gameoflife';
    var ws = new WebSocket(uri);
    var counter = 0;

    ws.onerror = function(event) {
        updateDisplay('WebSockets error: ' + event.data, function() {});
    };

    ws.onopen = function() {
        updateDisplay('WebSockets connection successful!', function() {
            ws.send(counter + '\n');
            counter += 1;
        });
    };

    ws.onclose = function() {
        updateDisplay('WebSockets connection closed.', function() {});
    };

    ws.onmessage = function(event) {
        updateDisplay(event.data, function() {
            ws.send(counter);
            counter += 1
        });
    };
});