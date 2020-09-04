import React from 'react';
import logo from '../logo.svg';
import './App.css';

import UserDetails from '../components/userDetails'

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <p>
          Välkommen till denna fantabulösa sida!
        </p>
        <UserDetails />
      </header>
    </div>
  );
}

export default App;
