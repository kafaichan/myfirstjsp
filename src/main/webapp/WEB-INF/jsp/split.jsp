<%--
  Created by IntelliJ IDEA.
  User: kafaichan
  Date: 2016/4/8
  Time: 11:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blueprint: Slide and Push Menus</title>

    <link rel="stylesheet" type="text/css" href="/resources/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/resources/css/bootstrap-theme.min.css" />

    <link rel="shortcut icon" href="../favicon.ico">
    <link rel="stylesheet" type="text/css" href="/resources/css/default.css" />
    <link rel="stylesheet" type="text/css" href="/resources/css/component.css" />
    <script src="/resources/js/modernizr.custom.js"></script>
    <script src="/resources/js/d3.js"></script>
    <script src="/resources/js/jquery-1.12.1.js"></script>

    <style>
        .node {
            stroke: #fff;
            cursor: pointer;
            stroke-width: 1.5px;
        }

        path.link {
            fill: none;
            stroke: #c9c9c9;
            stroke-width: 1.5px;
        }
    </style>

</head>

<body class="cbp-spmenu-push">
<nav class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-left" id="cbp-spmenu-s1">

    <div class="search-box">
        <h3><span class="glyphicon glyphicon-globe" aria-hidden="true"></span>&nbsp;Heterdemic</h3>
        <form class="form-inline">
            <input type="text" placeholder="请输入关键字">
            <button>
                <span class="glyphicon glyphicon-search"></span>
            </button>
        </form>
    </div>

    <div class="legend-box">
        <h4>Legend</h4>
        <table>
            <tbody>
            <tr>
                <td><span style="color:#1F77B4">•</span>&nbsp;Author</td>
                <td><span style="color:#AEC7E8">■</span>&nbsp;Paper&nbsp;</td>

            </tr>
            <tr>
                <td><span style="color: #FF7F0E;">♦</span>&nbsp;Venue&nbsp;</td>
                <td><span style="color: #FFBB78;">▲</span>&nbsp;Topic&nbsp;</td>
            </tr>
            <tr>
                <td><span style="color: #2CA02C;">■</span>&nbsp;Video&nbsp;</td>
            </tr>
            </tbody>
        </table>
    </div>

</nav>


<section class="buttonset">
    <!-- Class "cbp-spmenu-open" gets applied to menu and "cbp-spmenu-push-toleft" or "cbp-spmenu-push-toright" to the body -->
    <button id="showLeftPush"><span class="glyphicon glyphicon-th-list"></span></button>
</section>

<div class="main">
    <div id="map"></div>
</div>

<!-- graph start -->

<script>
    var w = window.innerWidth;
    var h = window.innerHeight;


    var focus_node = null, highlight_node = null;

    var text_center = false;
    var outline = false;

    var min_score = 0;
    var max_score = 1;

    var color = d3.scale.category20();

    var highlight_color = "#555";
    var highlight_trans = 0.1;

    var size = d3.scale.pow().exponent(1)
            .domain([1,100])
            .range([5,21]);

    var force = d3.layout.force()
            .linkDistance(120)
            .charge(-300)
            .size([w,h]);

    var default_node_color = "#ccc";
    //var default_node_color = "rgb(3,190,100)";
    var default_link_color = "#c9c9c9";
    var nominal_base_node_size = 5;
    var nominal_text_size = 10;
    var max_text_size = 24;
    var nominal_stroke = 1.5;
    var max_stroke = 4.5;
    var max_base_node_size = 33;
    var min_zoom = 0.1;
    var max_zoom = 7;

    var svg = d3.select("#map").append("svg");
    var zoom = d3.behavior.zoom().scaleExtent([min_zoom,max_zoom])
    var g = svg.append("g");
    svg.style("cursor","move");

    // no arrow
    g.append("svg:defs").selectAll("marker").data(["end"])
            .enter().append("svg:marker")
            .attr("id", String)
            //            .attr("viewBox", "0 -5 10 10")
            //            .attr("refX", 10)
            //            .attr("refY", 0)
            //            .attr("markerWidth", 6)
            //            .attr("markerHeight", 6)
            .attr("orient", "auto")
            .append("svg:path")
    //            .attr("d", "M0,-5L10,0L0,5");


    d3.json("/resources/js/testd3.json", function(error, graph) {

        var linkedByIndex = {};
        graph.links.forEach(function(d) {
            linkedByIndex[d.source + "," + d.target] = true;
        });

        function isConnected(a, b) {
            return linkedByIndex[a.index + "," + b.index] || linkedByIndex[b.index + "," + a.index] || a.index == b.index;
        }

        function hasConnections(a) {
            for (var property in linkedByIndex) {
                s = property.split(",");
                if ((s[0] == a.index || s[1] == a.index) && linkedByIndex[property])return true;
            }
            return false;
        }

        force
                .nodes(graph.nodes)
                .links(graph.links)
                .start();

        var link = g.append("svg:g").selectAll("path")
                .data(force.links()).enter()
                .append("svg:path")
                .attr("class", "link")
                .attr("marker-end", "url(#end)")
                .attr("id", function(d, i){ return "linkId_" + i;});

//        var link = g.selectAll(".link")
//                .data(graph.links)
//                .enter().append("line")
//                .attr("class", "link")
//                .style("stroke-width",nominal_stroke)
//                .style("stroke", function(d) {
//                    if (isNumber(d.score) && d.score>=0) return color(d.score);
//                    else return default_link_color; })


        var node = g.selectAll(".node")
                .data(graph.nodes)
                .enter().append("g")
                .attr("class", "node")
                .call(force.drag)

        node.append('title').text(function(d) {return d.name;});
        var clickedOnce = false;
        var timer;

        node.on("click", function(d){
            if(d.type === "circle") {
                console.log(d);
                if (clickedOnce) {
                    clickedOnce = false;
                    clearTimeout(timer);
//                    event.dblclick(d3.event);

                } else {
                    timer = setTimeout(function () {
                        // single click
                        clickedOnce = false;
                    }, 200);
                    clickedOnce = true;
                }
            }
        });

        node.on("dblclick.zoom", function(d) { d3.event.stopPropagation();
            var dcx = (window.innerWidth/2-d.x*zoom.scale());
            var dcy = (window.innerHeight/2-d.y*zoom.scale());
            zoom.translate([dcx,dcy]);
            g.attr("transform", "translate("+ dcx + "," + dcy  + ")scale(" + zoom.scale() + ")");
        });




        var tocolor = "fill";
        var towhite = "stroke";
        if (outline) {
            tocolor = "stroke"
            towhite = "fill"
        }
        
        var circle = node.append("path")
                .attr("d", d3.svg.symbol()
                        .size(function(d) { return Math.PI*Math.pow(size(d.probability)||nominal_base_node_size,2); })
                        .type(function(d) { return d.type; }))

                .style(tocolor, function(d) {
                    return color(d.group);})
                //                    else return default_node_color; })
                //.attr("r", function(d) { return size(d.size)||nominal_base_node_size; })
                .style("stroke-width", nominal_stroke)
                .style(towhite, "white");



        node.on("mouseover", function(d) {
                    set_highlight(d);
                })
                .on("mousedown", function(d) { d3.event.stopPropagation();
                    focus_node = d;
                    set_focus(d)
                    if (highlight_node === null) set_highlight(d)

                }	).on("mouseout", function(d) {
            exit_highlight();

        }	);

        d3.select(window).on("mouseup",
                function() {
                    if (focus_node!==null)
                    {
                        focus_node = null;
                        if (highlight_trans<1)
                        {
                            circle.style("opacity", 1);
                            link.style("opacity", 1);
                        }
                    }
                    if (highlight_node === null) exit_highlight();
                });

        function exit_highlight()
        {
            highlight_node = null;
            if (focus_node===null)
            {
                svg.style("cursor","move");
                if (highlight_color!="white")
                {
                    circle.style(towhite, "white");
                    link.style("stroke", function(o) {return (isNumber(o.score) && o.score>=0)?color(o.score):default_link_color});
                }
            }
        }

        function set_focus(d)
        {
            if (highlight_trans<1)  {
                circle.style("opacity", function(o) {
                    return isConnected(d, o) ? 1 : highlight_trans;
                });

                link.style("opacity", function(o) {
                    return o.source.index == d.index || o.target.index == d.index ? 1 : highlight_trans;
                });
            }
        }

        function set_highlight(d)
        {
            svg.style("cursor","pointer");
            if (focus_node!==null) d = focus_node;
            highlight_node = d;

            if (highlight_color!="white")
            {
                circle.style(towhite, function(o) {
                    return isConnected(d, o) ? highlight_color : "white";});

                link.style("stroke", function(o) {
                    return o.source.index == d.index || o.target.index == d.index ? highlight_color : ((isNumber(o.score) && o.score>=0)?color(o.score):default_link_color);

                });
            }
        }


        zoom.on("zoom", function() {
            var stroke = nominal_stroke;
            if (nominal_stroke*zoom.scale()>max_stroke) stroke = max_stroke/zoom.scale();
            link.style("stroke-width",stroke);
            circle.style("stroke-width",stroke);

            var base_radius = nominal_base_node_size;
            if (nominal_base_node_size*zoom.scale()>max_base_node_size) base_radius = max_base_node_size/zoom.scale();
            circle.attr("d", d3.svg.symbol()
                    .size(function(d) { return Math.PI*Math.pow(size(d.probability)*base_radius/nominal_base_node_size||base_radius,2); })
                    .type(function(d) { return d.type; }))

            g.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
        });

        svg.call(zoom);

        resize();
        //window.focus();
        d3.select(window).on("resize", resize);

        force.on("tick", function() {

            node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });

            link.attr("d", function(d){
                var dx = d.target.x - d.source.x,
                        dy = d.target.y - d.source.y,
                        dr = Math.sqrt(dx*dx + dy*dy);

                return "M" +
                        d.source.x + "," +
                        d.source.y + "A" +
                        dr + "," + dr + " 0 0,1 " +
                        d.target.x + "," +
                        d.target.y;
            });

            node.attr("cx", function(d) { return d.x; })
                    .attr("cy", function(d) { return d.y; });
        });

        function resize() {
            var width = window.innerWidth, height = window.innerHeight;
            svg.attr("width", width).attr("height", height);

            force.size([force.size()[0]+(width-w)/zoom.scale(),force.size()[1]+(height-h)/zoom.scale()]).resume();
            w = width;
            h = height;
        }

        var showAuthor, showPaper, showTopic, showVenue, showVideo;
        showAuthor = showPaper = showTopic = showVenue = showVideo = true;


        function vis_by_group(group){
            switch(group){
                case 1: return showAuthor;
                case 2: return showPaper;
                case 3: return showVenue;
                case 4: return showTopic;
                case 5: return showVideo;
                default: return true;
            }
        }

        function hideNodesAndEdge(type){
            switch(type){
                case 1: showAuthor = !showAuthor; break;
                case 2: showPaper = !showPaper; break;
                case 3: showVenue = !showVenue; break;
                case 4: showTopic = !showTopic; break;
                case 5: showVideo = !showVideo; break;
            }
            link.style("display", function(d) {
                var flag  = vis_by_group(d.source.group)&&vis_by_group(d.target.group);
                linkedByIndex[d.source.index + "," + d.target.index] = flag;
                return flag?"inline":"none";});

            node.style("display", function(d) {
                return vis_by_group(d.group)?"inline":"none";
            });
        }

        $(document).ready(function(){
            $("table tr:nth-child(1) td:nth-child(1)").click(
                    function(){
                        if(showAuthor) {
                            $(this).css({"background-color": "#212121"});
                        }else{
                            $(this).css({"background-color": "#3AB7DA"});
                        }
                        hideNodesAndEdge(1);
                    }
            );

            $("table tr:nth-child(1) td:nth-child(2)").click(
                    function(){
                        if(showPaper) {
                            $(this).css({"background-color": "#212121"});
                        }else{
                            $(this).css({"background-color": "#3AB7DA"});
                        }
                        hideNodesAndEdge(2);
                    }
            );

            $("table tr:nth-child(2) td:nth-child(1)").click(
                    function(){
                        if(showVenue) {
                            $(this).css({"background-color": "#212121"});
                        }else{
                            $(this).css({"background-color": "#3AB7DA"});
                        }
                        hideNodesAndEdge(3);
                    }
            );

            $("table tr:nth-child(2) td:nth-child(2)").click(
                    function(){
                        if(showTopic) {
                            $(this).css({"background-color": "#212121"});
                        }else{
                            $(this).css({"background-color": "#3AB7DA"});
                        }
                        hideNodesAndEdge(4);
                    }
            );

            $("table tr:nth-child(3) td:nth-child(1)").click(
                    function(){
                        if(showVideo) {
                            $(this).css({"background-color": "#212121"});
                        }else{
                            $(this).css({"background-color": "#3AB7DA"});
                        }
                        hideNodesAndEdge(5);
                    }
            );
        });
    });

    function isNumber(n) {
        return !isNaN(parseFloat(n)) && isFinite(n);
    }
</script>

<!-- // end of graph-->

<!-- Classie - class helper functions by @desandro https://github.com/desandro/classie -->
<script src="/resources/js/classie.js"></script>
<script>
    var menuLeft = document.getElementById( 'cbp-spmenu-s1' ),
            showLeftPush = document.getElementById( 'showLeftPush' ),
            body = document.body;


    showLeftPush.onclick = function() {
        classie.toggle( this, 'active' );
        classie.toggle( body, 'cbp-spmenu-push-toright' );
        classie.toggle( menuLeft, 'cbp-spmenu-open' );
    };
</script>
</body>
</html>
