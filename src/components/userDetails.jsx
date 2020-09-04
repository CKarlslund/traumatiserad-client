import React from 'react';
import ReactDOM from 'react-dom';

export default class UserDetails extends React.Component {
  constructor() {
    super();
    this.state = {
      users: [],
  };
  
}

componentDidMount() {

  fetch('https://api.traumatiserad.se/users')
  .then(results => {
    return results.json();
  }).then(data => {
    console.log(data);
    let users = data.map((user) => {
      return(
      <li key={user.UserId}>{user.Name}</li>
      )
    })
    this.setState({users: users})
  })
}

render() {
  return (
    <React.Fragment>
      <div>Users</div>
      <ul>{this.state.users}</ul>
      </React.Fragment>
  )
}}
