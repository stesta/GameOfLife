<apply template="base">
    <bind tag="main">
        <div id="board-container"></div>
    </bind>

    <bind tag="javascript">
        <script type="text/javascript" src="https://unpkg.com/systemjs@latest/dist/system.js"></script>
        <script type="text/javascript">
            SystemJS.config({
                map: {
                    'plugin-babel':         'https://unpkg.com/systemjs-plugin-babel@latest/plugin-babel.js',
                    'systemjs-babel-build': 'https://unpkg.com/systemjs-plugin-babel@latest/systemjs-babel-browser.js',
                    'react':                'https://unpkg.com/react@15.0.0/dist/react.min.js',
                    'react-dom':            'https://unpkg.com/react-dom@15.0.0/dist/react-dom.min.js',
                    'lodash':               'https://unpkg.com/lodash@latest/lodash.min.js'
                },
                transpiler: 'plugin-babel',
                meta: {
                    '*.jsx': {
                        babelOptions: {
                            react: true
                        }
                    }
                }
            });

            SystemJS.import('/scripts/app.jsx');
        </script>
    </bind>
</apply>