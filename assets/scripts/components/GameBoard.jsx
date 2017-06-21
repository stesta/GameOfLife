const gb = (props) => {
    const searchForArray = (haystack, needle) => {
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
    };

    const drawGrid = () => { 
        var c = document.getElementById('board');
            c.height = props.height;
            c.width = props.width;

        let canvasRatio = c.height / c.width;
        let windowRatio = window.innerHeight / window.innerWidth;
        let width = windowRatio < canvasRatio ? window.innerHeight / canvasRatio : window.innerWidth;
        let height = windowRatio < canvasRatio ? window.innerHeight : window.innerWidth * canvasRatio;

        c.style.width = width + 'px';
        c.style.height = height + 'px';

        let ctx = c.getContext('2d');
            ctx.clearRect(0, 0, props.height, props.width);

        for (var j = 1; j <= (props.height/props.cellSize); j++) { 
        for (var k = 1; k <= (props.width/props.cellSize); k++) {
            var elem = [j-(props.height/(props.cellSize*2)),k-(props.width/(props.cellSize*2))]
            ctx.fillStyle = '#333333';
            ctx.lineWidth = .5;
            ctx.strokeStyle = '#eeeeee';
            ctx.strokeRect((j*props.cellSize)-1, (k*props.cellSize)-1, props.cellSize, props.cellSize); 
            
            if (this.searchForArray(props.board, elem) != -1) {
                ctx.fillRect((j*props.cellSize)-1, (k*props.cellSize)-1, props.cellSize, props.cellSize);
            }  
        }}
    };

    return (
        <div>
            <div>Generation: {props.generation}</div>
            <canvas id="board"></canvas>
        </div>
    );
};
