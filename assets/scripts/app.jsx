import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';
import { cartesian } from '/scripts/utils.js';

class GameBoard extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            counter: 0,
            board: [],
            nextGenerationDelay: 0,
            running: false,
            width: 500,
            height: 500,
            cellSize: 5
        };
    }

    componentDidMount() {
        this.cells = cartesian(_.range(1,100), _.range(1,100));

        this.container = document.getElementById('board-container');
        
        this.canvas = document.getElementById('board');
        this.canvas.height = this.state.height;
        this.canvas.width = this.state.width;
        
        this.context = this.canvas.getContext('2d');
        this.context.strokeStyle = '#eeeeee';
        this.context.fillStyle = '#333333';
        this.context.lineWidth = .5;

        this.startGame();
    }

    getWebsocketUri() {
        let loc = window.location;
        let wsUri = loc.protocol === "https:" ? "wss:" : "ws:";
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
        let self = this;
        
        if (self.state.running === false)
        {
            self.setState({ running: true });
            let ws = new WebSocket(self.getWebsocketUri());

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
                let b = JSON.parse(event.data);
                self.setState({ board: b });
                this.drawGrid();
                self.nextGeneration(ws);
            };
        }
    }

    resetCanvas() {
        let canvasRatio = this.canvas.height / this.canvas.width;
        let windowRatio = window.innerHeight / window.innerWidth;
        let width = windowRatio < canvasRatio ? window.innerHeight / canvasRatio : window.innerWidth;
        let height = windowRatio < canvasRatio ? window.innerHeight : window.innerWidth * canvasRatio;
        this.canvas.style.width = width + 'px';
        this.canvas.style.height = height + 'px';
        
        this.context.clearRect(0, 0, this.state.height, this.state.width);
    }

    drawGrid() { 
        this.resetCanvas();

        // draw the grid
        _.map(this.cells, (elem) => {
            let x = (elem[0]*this.state.cellSize-1);
            let y = (elem[1]*this.state.cellSize-1);
            this.context.strokeRect(x, y, this.state.cellSize, this.state.cellSize); 
        });
        
        // fill in live cells
        _.map(this.state.board, (elem) => {
            let x = (elem[0]*this.state.cellSize-1) + (this.state.height/2);
            let y = (elem[1]*this.state.cellSize-1) + (this.state.width/2);
            this.context.fillRect(x, y, this.state.cellSize, this.state.cellSize);
        });
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