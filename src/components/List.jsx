var React = require('react');
var ListItem = require('./ListItem.jsx');
var HTTP = require('../services/httpservice');

var List = React.createClass({
  getInitialState: function() {
    return { pups: [] };
  },
  componentWillMount: function () {

    HTTP.get('/pups').then(function(data){
      console.log('DATA: '+ data)
      this.setState({pups: data});
    }.bind(this));
  },
  render: function() {
    var listItems = this.state.pups.map(function(item) {
      return <ListItem key={item.id} pup={item.text} />;
    });

    return (<ul>{listItems}</ul>);
  }

});


module.exports = List;
