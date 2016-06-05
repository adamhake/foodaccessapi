import $ from 'jquery';
import storeForm from "./modules/storeForm";
import React from "react";
import ReactDOM from 'react-dom';
import _ from "lodash";
import Map from "./modules/map";
import StoreForm from "./modules/storeForm"

$(document).ready( ()=> {
  new Map();
  new StoreForm();
});


const StoreList = React.createClass({
  getInitialState() {
    return {stores: [], allStores: []};
  },
  componentDidMount(){
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({stores: data.stores, allStores: data.stores});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    })
  },
  handleSearchSubmit(term){
    let totalStores = this.state.allStores.length;
    if(term.length < 3){
      if(this.state.stores.length < totalStores){
        this.setState({stores: this.state.allStores});
      }
    } else{
      var stores = _.filter(this.state.allStores, store =>{
        var name = store.name.trim();
        name = _.replace(name, " ", "");
        name = name.toLowerCase();
        return _.includes(name, term);
      });
      this.setState({stores: stores});
    }
  },
  render(){
    return(<div className="store-list">
      <TableSearchBox onSearchSubmit={this.handleSearchSubmit}/>
      <TableList stores={this.state.stores} />
    </div>);
  }
});

const TableList = React.createClass({
  render(){
    var storeNodes = this.props.stores.map(store => {
      return(<TableRow
        key={store._id}
        id={store._id}
        name={store.name}
        category={store.category}
        updated={store.updated}
      />);
    });
    return(<table className="store-list--stores">
      <thead>
        <tr>
          <th>Name</th>
          <th>Category</th>
          <th>Last Updated</th>
          <th></th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        {storeNodes}
      </tbody>
    </table>);
  }
});

const TableRow = React.createClass({
  formatCategory(){
    return _.startCase(this.props.category);
  },
  formatUpdated(){
    let date = new Date(this.props.updated);
    return date.toLocaleDateString()
  },
  render(){
    return(<tr>
      <td>
        <a href={`/stores/${this.props.id}`}>{this.props.name}</a>
      </td>
      <td>{this.formatCategory()}</td>
      <td>{this.formatUpdated()}</td>
      <td>
        <a href={`/stores/${this.props.id}/edit`}>Edit</a>
      </td>
      <td>Delete</td>
    </tr>);
  }
});

const TableSearchBox = React.createClass({
  getInitialState() {
  return {searchTerm: ''};
  },
  handleSearchTermChange(e) {
    this.setState({searchTerm: e.target.value});
    let term = this.state.searchTerm.trim();
    term = _.replace(term, " ", "");
    term = term.toLowerCase();
    this.props.onSearchSubmit(term)

  },
  render(){
    return(<div className="store-list-search">
      <input
        type="text"
        placeholder="Search Store"
        value={this.state.searchTerm}
        onChange={this.handleSearchTermChange}
      />
    </div>);
  }
});

if($('#storeList').length){
  ReactDOM.render(<StoreList url="/api/v1/stores" />, document.getElementById('storeList'));
}
