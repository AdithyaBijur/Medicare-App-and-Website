import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
// import App from './App';
import * as serviceWorker from './serviceWorker';
import '../node_modules/bootstrap/dist/css/bootstrap.min.css';
import { BrowserRouter, Route } from 'react-router-dom';
import Home from './Home/Home.js';
import Login from './login.js';
import Admin_Home from './Admin_Home/Admin_Home.js';

ReactDOM.render(
    <BrowserRouter>
        <div>
            <Route path="/Login" component={Login} exact />
            <Route path="/" component={Home} exact />
            <Route path="/Admin" component={Admin_Home} exact />
        </div>
    </BrowserRouter>, document.getElementById('root'));

// ReactDOM.render(<App />, document.getElementById('root'));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
