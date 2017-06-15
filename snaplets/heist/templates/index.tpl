<apply template="base">
    <bind tag="sidebar">
      <h2>Game of Haskell</h2>
      <p>
        Conway's Game of Life 
      </p>
      <p>
        For more information regarding the construction of this application please see my <a href="#">Building a Web Application in Haskell</a> blog post series.
      </p>
    </bind>

    <bind tag="main">
      <div id="board-container"></div> 
    </bind>

    <bind tag="javascript">
      <script type="text/javascript" src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
      <script type="text/javascript" src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/react/15.3.1/react.js"></script>
      <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/react/15.3.1/react-dom.js"></script>
      <script type="text/javascript" src="https://code.createjs.com/easeljs-0.8.2.min.js"></script>
      <script src="/scripts/app.jsx" type="text/babel"></script>
    </bind>
</apply>
