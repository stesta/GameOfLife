<apply template="base">
    <link rel="stylesheet" type="text/css" href="/styles/console.css"/>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/scripts/console.js"></script>

    <form id="login">
        <code>URI: </code><input type="text" size="64" id="uri" value="ws://localhost:8000/console/bash" />
        <input type="submit" style="display: none" />
    </form>
    
    <div id="console" style="display: none">
        <div id="console-output"></div>
        <form id="console-input">
            <code>$ </code><input type="text" size="64" id="line" />
            <input type="submit" style="display: none" />
        </form>
    </div>
</apply>