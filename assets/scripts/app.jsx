class GameBoard extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            counter: 0,
            board: '',
            nextGenerationDelay: 200,
            running: false
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
            ws.send(self.state.counter);
            self.setState({ counter: self.state.counter+1 });
        }, self.state.nextGenerationDelay);
    }

    drawBoard() {

    }

    startGame() {
        if (self.state.running === false)
        {
            var self = this;
            self.setState({ running: true });
            var ws = new WebSocket(getWebsocketUri());

            ws.onerror = (event) => {
                self.setState({ 
                    board: 'WebSockets error: ' + event.data,
                    running: false
                });
            };

            ws.onopen = () => {
                self.setState({ board: 'WebSockets connection successful!' });
                nextGeneration(ws);
            };

            ws.onclose = () => {
                self.setState({ 
                    board: 'WebSockets connection closed.',
                    running: false
                });
            };

            ws.onmessage = (event) => {
                self.setState({ board: event.data });
                nextGeneration(ws);
            };
        }
    }

    componentDidMount() {
        startGame();
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