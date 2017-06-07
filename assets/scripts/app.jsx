class GameBoard extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            counter: 0,
            board: ''
        };
    }

    componentDidMount() {
        var self = this;
        var loc = window.location, new_uri;
        if (loc.protocol === "https:") {
            new_uri = "wss:";
        } else {
            new_uri = "ws:";
        }
        new_uri += "//" + loc.host;
        new_uri += loc.pathname + "gameoflife";
        var ws = new WebSocket(new_uri);

        ws.onerror = (event) => {
            self.setState({ board: 'WebSockets error: ' + event.data });
        };

        ws.onopen = () => {
            self.setState({ board: 'WebSockets connection successful!' });

            setTimeout(() => {
                ws.send(self.state.counter);
                self.setState({ counter: self.state.counter+1 });
            }, 200);
        };

        ws.onclose = () => {
            self.setState({ board: 'WebSockets connection closed.' });
        };

        ws.onmessage = (event) => {
            self.setState({ board: event.data });
            
            setTimeout(() => {
                ws.send(self.state.counter);
                self.setState({ counter: self.state.counter+1 });
            }, 200);
        };
    }

    render() {
        return (
            <div>{this.state.board}</div>
        );
    }
};

ReactDOM.render(
    <GameBoard />,
    document.getElementById('board')
);