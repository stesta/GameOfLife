class GameBoard extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            counter: 0,
            board: [],
            nextGenerationDelay: 200,
            running: false,
            boardWidth: 400,
            boardHeight: 400
        };
    }

    getWebsocketUri() {
        var loc = window.location;
        var wsUri = loc.protocol === "https:" ? "wss:" : "ws:";
        wsUri += "//" + loc.host;
        wsUri += loc.pathname + "gameoflife";

        return wsUri;
    }

    nextGeneration(ws) {
        setTimeout(() => {
            ws.send(this.state.counter);
            this.setState({ counter: this.state.counter+1 });
        }, this.state.nextGenerationDelay);
    }

    drawBoard() {

    }

    startGame() {
        var self = this;
        
        if (self.state.running === false)
        {
            self.setState({ running: true });
            var ws = new WebSocket(self.getWebsocketUri());

            ws.onerror = (event) => {
                self.setState({ 
                    board: 'WebSockets error: ' + event.data,
                    running: false
                });
            };

            ws.onopen = () => {
                self.setState({ board: 'WebSockets connection successful!' });
                self.nextGeneration(ws);
            };

            ws.onclose = () => {
                self.setState({ 
                    board: 'WebSockets connection closed.',
                    running: false
                });
            };

            ws.onmessage = (event) => {
                var b = JSON.parse(event.data);
                self.setState({ board: b });
                this.drawGrid();

                self.nextGeneration(ws);
                
            };
        }
    }

    searchForArray(haystack, needle){
        var i, j, current;
        for(i = 0; i < haystack.length; ++i){
            if(needle.length === haystack[i].length){
            current = haystack[i];
            for(j = 0; j < needle.length && needle[j] === current[j]; ++j);
            if(j === needle.length)
                return i;
            }
        }
        return -1;
    }

    drawGrid() { 
        var rectSize = 10;
        var c = document.getElementById('board');
        var ctx = c.getContext('2d');
            ctx.clearRect(0, 0, 400, 400);

        for (var j = 1; j < 400; j++) { 
        for (var k = 1; k < 400; k++) {
            var elem = [j-5,k-5]
            ctx.fillStyle = '#333333';
            ctx.lineWidth = 1;
            ctx.strokeStyle = '#999999';
            ctx.strokeRect((j*rectSize)-1, (k*rectSize)-1, rectSize, rectSize); 
            
            if (this.searchForArray(this.state.board, elem) != -1) {
                ctx.fillRect((j*rectSize)-1, (k*rectSize)-1, rectSize, rectSize);
            }  
        }}
    }

    componentDidMount() {
        this.startGame();
    }

    render() {
        return (
            <canvas id="board"></canvas>
        );
    }
};

ReactDOM.render(
    <GameBoard />,
    document.getElementById('board-container')
);