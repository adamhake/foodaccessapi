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
  allStores: [],
  allStoresCount: 0,
  getInitialState() {
    return {
      stores: [],
      sorted: {
        type: "name",
        dir: "ASC"
      }
    };
  },
  componentDidMount(){
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: false,
      success: function(data) {
        let stores = _.sortBy(data.stores, store => {
          return store.name;
        });
        this.setState({stores: stores});
        this.allStores = stores;
        this.allStoresCount = stores.length;
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    })
  },
  componentDidUpdate(){
    // reset sort classes
    $('.sortable').removeClass('-sorted -asc -desc');
    let currFilter = this.state.sorted;
    let label = _.startCase(currFilter.type);
    let dir = _.lowerCase(currFilter.dir);
    $(`.sortable:contains('${label}')`).addClass(`-sorted -${dir}`);
  },
  handleTableSort(type){
    console.log(type);
    let sortedStores = [];
    let filterState = this.setFilterState(type);
    switch (type) {
      case 'name':
        sortedStores = _.sortBy(this.state.stores, store => {
          return store.name;
        });

        break;
      case 'category':
        sortedStores = _.sortBy(this.state.stores, store => {
          return store.category;
        });
        break;
      case 'streetAddress':
        sortedStores = _.sortBy(this.state.stores, store => {
          return store.address.street;
        });
        break;
      default:
        return;
    }
    if(filterState.dir == 'DESC'){
      _.reverse(sortedStores);
    }
    this.setState({stores: sortedStores, sorted: filterState});
  },
  handleSearchSubmit(term){
    if(term.length < 3){
      if(this.state.stores.length < this.allStoresCount){
        this.setState({stores: this.allStores, sorted:{type: "name", dir: "asc"}});
      }
    } else{
      var stores = _.filter(this.allStores, store => {
        var name = store.name.trim();
        name = _.replace(name, " ", "");
        name = name.toLowerCase();
        return _.includes(name, term);
      });
      this.setState({stores: stores});
    }
  },
  setFilterState(type){
    if(this.state.sorted == false || this.state.sorted.type !== type){
      return {
        type: type,
        dir: "ASC"
      };
    } else {
      return{
        type: type,
        dir: this.state.sorted.dir == "ASC" ? "DESC" : "ASC"
      }
    }
  },
  render(){
    return(<div className="store-list">
      <TableSearchBox onSearchSubmit={this.handleSearchSubmit}/>
      <TableList onSort={this.handleTableSort} stores={this.state.stores} />
    </div>);
  }
});

const TableList = React.createClass({
  handleOnFilter(e){
    let target = _.camelCase($(e.target).text());
    this.props.onSort(target);
  },
  render(){
    var storeNodes = this.props.stores.map(store => {
      return(<TableRow
        key={store._id}
        id={store._id}
        name={store.name}
        streetAddress={store.address.street}
        updated={store.updated}
        category={store.category}
      />);
    });
    return(<table className="store-list--stores">
      <thead>
        <tr>
          <th className="sortable -sorted -asc" onClick={this.handleOnFilter}>Name</th>
          <th className="sortable" onClick={this.handleOnFilter}>Street Address</th>
          <th className="sortable" onClick={this.handleOnFilter}>Category</th>
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
      <td>{this.props.streetAddress}</td>
      <td>{this.formatCategory()}</td>
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
