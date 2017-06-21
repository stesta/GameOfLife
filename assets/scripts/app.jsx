class GameBoard extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            counter: 0,
            board: [],
            nextGenerationDelay: 50,
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
                this.drawGrid();
                
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
        var rectSize = 5;
        var canvasHeight = 500;
        var canvasWidth = 500;
        var c = document.getElementById('board');
            c.height = canvasHeight;
            c.width = canvasWidth;

        var canvasRatio = c.height / c.width;
        var windowRatio = window.innerHeight / window.innerWidth;
        var width;
        var height;

        if (windowRatio < canvasRatio) {
            height = window.innerHeight;
            width = height / canvasRatio;
        } else {
            width = window.innerWidth;
            height = width * canvasRatio;
        }

        c.style.width = width + 'px';
        c.style.height = height + 'px';

        var ctx = c.getContext('2d');
            ctx.clearRect(0, 0, canvasHeight, canvasWidth);

        for (var j = 1; j <= (canvasHeight/rectSize); j++) { 
        for (var k = 1; k <= (canvasWidth/rectSize); k++) {
            var elem = [j-(canvasHeight/(rectSize*2)),k-(canvasWidth/(rectSize*2))]
            ctx.fillStyle = '#333333';
            ctx.lineWidth = .5;
            ctx.strokeStyle = '#eeeeee';
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
            <div>
                <div>Generation: {this.state.counter}</div>
                <canvas id="board"></canvas>
            </div>
        );
    }
};

ReactDOM.render(
    <GameBoard />,
    document.getElementById('board-container')
);