import React from 'react';
import { BrowserRouter as Router, Route, Switch} from 'react-router-dom';

import './css/style.css';

import Home from './home.coffee'
import Nav from './nav.coffee'

import {url_root} from './config.coffee'
import vm from './ViewModel.coffee'

class App extends React.Component{
    constructor(props) {
        super(props);
        vm.forceUpdate = ()=>{this.forceUpdate.bind(this)()};
        vm.init();
    }
    render(){
        return (
        <Router>
            <div className="container-fluid">
                <Nav title="react socket.io" vm={vm}/>
                <Switch>
                    <Route exact path={url_root} render={props =><Home vm={vm} {...props}/>}/>
                </Switch>
            </div>
        </Router>
        );
    }
}

module.exports = App;
