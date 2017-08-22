<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/vis/4.20.1/vis.min.js"></script>
<link href="http://visjs.org/dist/vis-network.min.css" rel="stylesheet" type="text/css" />
<script src="resources/jquery-3.2.1.min.js"></script>
<script>
	var nodes = null;
	var edges = null;
	var network = null;
	// randomly create some nodes and edges
	var data = getScaleFreeNetwork(25);
	var seed = 2;

	function setDefaultLocale() {
	  var defaultLocal = navigator.language;
	}
	
	function destroy() {
	  if (network !== null) {
	    network.destroy();
	    network = null;
	  }
	}
	
	function draw() {
	  destroy();
	  nodes = [];
	  edges = [];
	
	  // create a network
	  var container = document.getElementById('mynetwork');
	  var options = {
	    layout: {randomSeed:seed}, // just to make sure the layout is the same when the locale is changed
	    locale: "en",
	    manipulation: {
	      addNode: function (data, callback) {
	        // filling in the popup DOM elements
	        document.getElementById('operation').innerHTML = "Add Node";
	        document.getElementById('node-id').value = data.id;
	        document.getElementById('node-label').value = data.label;
	        document.getElementById('saveButton').onclick = saveData.bind(this, data, callback);
	        document.getElementById('cancelButton').onclick = clearPopUp.bind();
	        document.getElementById('network-popUp').style.display = 'block';
	      },
	      editNode: function (data, callback) {
	        // filling in the popup DOM elements
	        document.getElementById('operation').innerHTML = "Edit Node";
	        document.getElementById('node-id').value = data.id;
	        document.getElementById('node-label').value = data.label;
	        document.getElementById('saveButton').onclick = saveData.bind(this, data, callback);
	        document.getElementById('cancelButton').onclick = cancelEdit.bind(this,callback);
	        document.getElementById('network-popUp').style.display = 'block';
	      },
	      addEdge: function (data, callback) {
	        if (data.from == data.to) {
	          var r = confirm("Do you want to connect the node to itself?");
	          if (r == true) {
	            callback(data);
	          }
	        }
	        else {
	          callback(data);
	        }
	      }
	    }
	  };
	  network = new vis.Network(container, data, options);
	  
	  network.on('click', function(properties){
			var ids = properties.nodes;
			alert(ids);
		});
	}
	
	function clearPopUp() {
	  document.getElementById('saveButton').onclick = null;
	  document.getElementById('cancelButton').onclick = null;
	  document.getElementById('network-popUp').style.display = 'none';
	}
	
	function cancelEdit(callback) {
	  clearPopUp();
	  callback(null);
	}
	
	function saveData(data,callback) {
	  data.id = document.getElementById('node-id').value;
	  data.label = document.getElementById('node-label').value;
	  clearPopUp();
	  callback(data);
	}
	
	function init() {
	  setDefaultLocale();
	  draw();
	}
	
	
	function loadJSON(path, success, error) {
		  var xhr = new XMLHttpRequest();
		  xhr.onreadystatechange = function () {
		    if (xhr.readyState === 4) {
		      if (xhr.status === 200) {
		        success(JSON.parse(xhr.responseText));
		      }
		      else {
		        error(xhr);
		      }
		    }
		  };
		  xhr.open('GET', path, true);
		  xhr.send();
		}


		function getScaleFreeNetwork(nodeCount) {
		  var nodes = [];
		  var edges = [];
		  var connectionCount = [];

		  // randomly create some nodes and edges
		  for (var i = 0; i < nodeCount; i++) {
		    nodes.push({
		      id: i,
		      label: String(i)
		    });

		    connectionCount[i] = 0;

		    // create edges in a scale-free-network way
		    if (i == 1) {
		      var from = i;
		      var to = 0;
		      edges.push({
		        from: from,
		        to: to
		      });
		      connectionCount[from]++;
		      connectionCount[to]++;
		    }
		    else if (i > 1) {
		      var conn = edges.length * 2;
		      var rand = Math.floor(Math.random() * conn);
		      var cum = 0;
		      var j = 0;
		      while (j < connectionCount.length && cum < rand) {
		        cum += connectionCount[j];
		        j++;
		      }


		      var from = i;
		      var to = j;
		      edges.push({
		        from: from,
		        to: to
		      });
		      connectionCount[from]++;
		      connectionCount[to]++;
		    }
		  }

		  return {nodes:nodes, edges:edges};
		}

		var randomSeed = 764; // Math.round(Math.random()*1000);
		function seededRandom() {
		  var x = Math.sin(randomSeed++) * 10000;
		  return x - Math.floor(x);
		}

		function getScaleFreeNetworkSeeded(nodeCount, seed) {
		  if (seed) {
		    randomSeed = Number(seed);
		  }
		  var nodes = [];
		  var edges = [];
		  var connectionCount = [];
		  var edgesId = 0;


		  // randomly create some nodes and edges
		  for (var i = 0; i < nodeCount; i++) {
		    nodes.push({
		      id: i,
		      label: String(i)
		    });

		    connectionCount[i] = 0;

		    // create edges in a scale-free-network way
		    if (i == 1) {
		      var from = i;
		      var to = 0;
		      edges.push({
		        id: edgesId++,
		        from: from,
		        to: to
		      });
		      connectionCount[from]++;
		      connectionCount[to]++;
		    }
		    else if (i > 1) {
		      var conn = edges.length * 2;
		      var rand = Math.floor(seededRandom() * conn);
		      var cum = 0;
		      var j = 0;
		      while (j < connectionCount.length && cum < rand) {
		        cum += connectionCount[j];
		        j++;
		      }


		      var from = i;
		      var to = j;
		      edges.push({
		        id: edgesId++,
		        from: from,
		        to: to
		      });
		      connectionCount[from]++;
		      connectionCount[to]++;
		    }
		  }

		  return {nodes:nodes, edges:edges};
		}
	
	
	
// $(function(){

// 	var count = 1;
// 	var nodes = [
// 		{id: 1, label: '사용자 이름'},
//     ];
// // 	var nodes = new vis.DataSet([{id: 1, label: '사용자 이름'}]);

//    	var edges = [
//    	];
   
//    	var event = [
//    	];

//    	var container = document.getElementById('graphArea');

//    	var data = {
//    		nodes: nodes,
//    		edges: edges
// //    	event: 
//    	};

   	
//    	var options = {
//  		enabled: false,
//           addNode: function (data, callback) {
//               console.log('add', data);
//           },
//           editNode: function (data, callback) {
//               console.log('edit', data);
//           },
//           addEdge: function (data, callback) {
//               console.log('add edge', data);
//               if (data.from == data.to) {
//                   var r = confirm("Do you want to connect the node to itself?");
//                   if (r === true) {
//                       callback(data);
//                   }
//               }
//               else {
//                   callback(data);
//               }
//           }
//    	}
//    	var graph = new vis.Network(container, data, options);
   
//    	$("#addButton").on('click', function(){
//    		nodes.push({id:++count, label: $("#nodeName").val()});
// // 	    alert(count);
// // 	    alert(nodes);
// 		alert("버튼 눌려줬다");//+$("#nodeName").val());d
// 		data = {nodes: nodes, edges: edges};
// 		graph = new vis.Network(container, data, {});
	   
// 		graph.on('click', function(properties){
// 			var ids = properties.nodes;
// // 			var clickedNode = nodes.get(ids);
// 			alert(ids);
// 		});
// 	});
// })
</script>
<style type="text/css">
    body, select {
      font: 10pt sans;
    }
    #mynetwork {
      position:relative;
      width: 800px;
      height: 600px;
      border: 1px solid lightgray;
    }
    table.legend_table {
      font-size: 11px;
      border-width:1px;
      border-color:#d3d3d3;
      border-style:solid;
    }
    table.legend_table,td {
      border-width:1px;
      border-color:#d3d3d3;
      border-style:solid;
      padding: 2px;
    }
    div.table_content {
      width:80px;
      text-align:center;
    }
    div.table_description {
      width:100px;
    }

    #operation {
      font-size:28px;
    }
    #network-popUp {
      display:none;
      position:absolute;
      top:350px;
      left:170px;
      z-index:299;
      width:250px;
      height:120px;
      background-color: #f9f9f9;
      border-style:solid;
      border-width:3px;
      border-color: #5394ed;
      padding:10px;
      text-align: center;
    }
  </style>
</head>
<body onload="init();">
<h2>마인드맵 단위 테스트(CRUD)</h2>

<div id="network-popUp">
  <span id="operation">새로생겨야 하는 메뉴</span> <br>
  <table style="margin:auto;"><tr>
    <td>id</td><td><input id="node-id" value="new value" /></td>
  </tr>
    <tr>
      <td>label</td><td><input id="node-label" value="new value" /></td>
    </tr></table>
  <input type="button" value="save" id="saveButton" />
  <input type="button" value="cancel" id="cancelButton" />
</div>
<br />
<div id="mynetwork">

</div>
</body>
<!-- <body> -->
<!-- <div id="graphArea" style="height: 800px"> -->

<!-- </div> -->
<!-- <div id="graphCURD"> -->
<!-- 	<input id="nodeName" type="text" placeholder="노드 이름"> -->
<!-- 	<input id="addButton" type="button" value="노드 추가하기"> -->
<!-- </div> -->

<!-- </body> -->

</html>