<%--
  Created by IntelliJ IDEA.
  User: kafaichan
  Date: 2016/3/26
  Time: 10:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>MyD3Js</title>
    <script src="/resources/js/d3.js"></script>

    <style>
        .node {
            stroke: #fff;
            cursor: pointer;
            stroke-width: 1.5px;
        }

        <%--.node-active{--%>
            <%--stroke: #555;--%>
            <%--stroke-width: 1.5px;--%>
        <%--}--%>

        /*.link {*/
            /*stroke: #555;*/
            /*stroke-opacity: .3;*/
        /*}*/

        <%--.link-active {--%>
            <%--stroke-opacity: 1;--%>
        <%--}--%>

        <%--.overlay {--%>
            <%--fill: none;--%>
            <%--pointer-events: all;--%>
        <%--}--%>

        <%--#map{--%>
            <%--border: 2px #555 dashed;--%>
            <%--width:500px;--%>
            <%--height:400px;--%>
        <%--}--%>


        path.link {
            fill: none;
            stroke: #c9c9c9;
            stroke-width: 1.5px;
        }

        <%--circle {--%>
            <%--fill: #ccc;--%>
            <%--stroke: #fff;--%>
            <%--stroke-width: 1.5px;--%>
        <%--}--%>
    </style>
</head>

<body>
<div id="map"></div>

<script>
    var w = window.innerWidth;
    var h = window.innerHeight;
//    var margin = {top: -5, right: -5, bottom: -5, left: -5};
//    var w = 600;
//    var h = 450;

    var keyc = true, keys = true, keyt = true, keyr = true, keyx = true, keyd = true, keyl = true, keym = true, keyh = true, key1 = true, key2 = true, key3 = true, key0 = true

    var focus_node = null, highlight_node = null;

    var text_center = false;
    var outline = false;

    var min_score = 0;
    var max_score = 1;

    var color = d3.scale.category20();

    var highlight_color = "#555";
    var highlight_trans = 0.1;

    //    var size = d3.scale.pow().exponent(1)
    //            .domain([1,100])
    //            .range([8,24]);


    var drag = d3.behavior.drag()
            .origin(function(d) { return d; })
            .on("dragstart", dragstarted)
            .on("drag", dragged)
            .on("dragend", dragended);


    function dragstarted(d) {
        d3.event.sourceEvent.stopPropagation();
        d3.select(this).classed("dragging", true);
        force.start();
    }

    function dragged(d) {
        d3.select(this).attr("cx", d.x = d3.event.x).attr("cy", d.y = d3.event.y);
    }

    function dragended(d) {
        d3.select(this).classed("dragging", false);
    }


    var force = d3.layout.force()
            .linkDistance(120)
            .charge(-300)
            .size([w,h]);
//            .size([w + margin.left + margin.right, h + margin.top + margin.bottom]);


    var default_node_color = "#ccc";
    var default_link_color = "#c9c9c9";
    var nominal_base_node_size = 8;
    var nominal_text_size = 10;
    var max_text_size = 24;
    var nominal_stroke = 1.5;
    var max_stroke = 4.5;
    var max_base_node_size = 36;
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
            .attr("viewBox", "0 -5 10 10")
            .attr("refX", 15)
            .attr("refY", -1.2)
            .attr("markerWidth", 5.5)
            .attr("markerHeight", 5.5)
            .attr("orient", "auto")
            .append("svg:path")
            .attr("d", "M0,-5L10,0L0,5");


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

        force.nodes(graph.nodes).links(graph.links).start();

        var path = g.append("svg:g").selectAll("path")
                .data(force.links()).enter()
                .append("svg:path")
                .attr("class", "link")
                .attr("marker-end", "url(#end)")
                .attr("id", function(d, i){ return "linkId_" + i;})


        var node = g.selectAll(".node")
                .data(graph.nodes)
                .enter().append("g")
                .attr("class", "node")
                //                .call(force.drag)
                .call(drag);

        node.append('title').text(function(d) {return d.name;});


        // single click or double click
        var clickedOnce = false;
        var timer;

        node.on("click", function(d){
            if(d.type === "circle") {
                console.log(d);
                if (clickedOnce) {
                    clickedOnce = false;
                    clearTimeout(timer);
                    event.dblclick(d3.event);

                } else {
                    timer = setTimeout(function () {
                        // single click
                        $(document).ready(function(){
                            var a = $('.flip-container').find('.flipper');
                            if(!a.hasClass('flipped'))a.addClass('flipped');

                            setTimeout(function(){
                                $("#avatar").attr("src", d.avatar);
                                $("#authorname").text(d.name);
                                $("#dept").html("<span class=\"glyphicon glyphicon-tags\"></span>&nbsp;" + d.dept);
                                $("#dept-position").html("<span class=\"glyphicon glyphicon-briefcase\"></span>&nbsp;" + d.position);
                                $("#email").text(" Email: " + d.email);
                                $("#homepage").text(" Personal Homepage: " + d.homepage);
                                $("#homepage").attr("href", d.homepage);

                                $("#research-interest").empty();

                                for(var item in d.interests){
                                    $("#research-interest").append("<span class=\"badge alert-info\">" + d.interests[item] + "</span>");
                                }
                                a.removeClass('flipped');
                            },500);
                        });

                        clickedOnce = false;
                    }, 200);
                    clickedOnce = true;
                }
            }
        });

        node.on("dblclick.zoom", function(d) { d3.event.stopPropagation();
            var dcx = (window.innerWidth/2-d.x*zoom.scale());
            var dcy = (window.innerHeight/2-d.y*zoom.scale());
//            var dcx = ((w + margin.left + margin.right)/2-d.x*zoom.scale());
//            var dcy = ((h + margin.top + margin.bottom)/2-d.y*zoom.scale());
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
                        //                        .size(function(d) { return Math.PI*Math.pow(size(d.size)||nominal_base_node_size,2); })
                        .type(function(d) { return d.type; }))

                .style(tocolor, function(d) {
                    return color(d.group);
//                    if (isNumber(d.score) && d.score>=0) return color(d.score);
//                    else return default_node_color;
                })
                //.attr("r", function(d) { return size(d.size)||nominal_base_node_size; })
                .style("stroke-width", nominal_stroke)
                .style(towhite, "white");


//        var text = g.selectAll(".text")
//                .data(graph.nodes)
//                .enter().append("text")
//                .attr("dy", ".35em")
//                .style("font-size", nominal_text_size + "px")

//        if (text_center)
//            text.text(function(d) { return d.id; })
//                    .style("text-anchor", "middle");
//        else
//            text.attr("dx", function(d) {return (size(d.size)||nominal_base_node_size);})
//                    .text(function(d) { return '\u2002'+d.id; });

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
//                            text.style("opacity", 1);
                            path.style("opacity", 1);
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
//                    text.style("font-weight", "normal");
                    path.style("stroke", function(o) {return (isNumber(o.score) && o.score>=0)?color(o.score):default_link_color});
                }

            }
        }

        function set_focus(d)
        {
            if (highlight_trans<1)  {
                circle.style("opacity", function(o) {
                    return isConnected(d, o) ? 1 : highlight_trans;
                });

//                text.style("opacity", function(o) {
//                    return isConnected(d, o) ? 1 : highlight_trans;
//                });

                path.style("opacity", function(o) {
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
//                text.style("font-weight", function(o) {
//                    return isConnected(d, o) ? "bold" : "normal";});
                path.style("stroke", function(o) {
                    return o.source.index == d.index || o.target.index == d.index ? highlight_color : ((isNumber(o.score) && o.score>=0)?color(o.score):default_link_color);

                });
            }
        }


        zoom.on("zoom", function() {
//            var stroke = nominal_stroke;
//            if (nominal_stroke*zoom.scale()>max_stroke) stroke = max_stroke/zoom.scale();
//            path.style("stroke-width",stroke);
//            circle.style("stroke-width",stroke);
//
//            var base_radius = nominal_base_node_size;
//            if (nominal_base_node_size*zoom.scale()>max_base_node_size) base_radius = max_base_node_size/zoom.scale();
//            circle.attr("d", d3.svg.symbol()
//                    .size(function(d) { return Math.PI*Math.pow(size(d.size)*base_radius/nominal_base_node_size||base_radius,2); })
//                    .type(function(d) { return d.type; }))

            //circle.attr("r", function(d) { return (size(d.size)*base_radius/nominal_base_node_size||base_radius); })
//            if (!text_center) text.attr("dx", function(d) { return (size(d.size)*base_radius/nominal_base_node_size||base_radius); });

//            var text_size = nominal_text_size;
//            if (nominal_text_size*zoom.scale()>max_text_size) text_size = max_text_size/zoom.scale();
//            text.style("font-size",text_size + "px");

            g.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
        });

        svg.call(zoom);

        resize();
        //window.focus();
        d3.select(window).on("resize", resize).on("keydown", keydown);

        force.on("tick", function() {
            node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
//            text.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });

            path.attr("d", function(d){
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
//            var width = w + margin.left + margin.right, height = h + margin.top + margin.bottom;
            svg.attr("width", width).attr("height", height);

            force.size([force.size()[0]+(width-w)/zoom.scale(),force.size()[1]+(height-h)/zoom.scale()]).resume();
            w = width;
            h = height;
        }

        function keydown() {
            if (d3.event.keyCode==32) {  force.stop();}
            else if (d3.event.keyCode>=48 && d3.event.keyCode<=90 && !d3.event.ctrlKey && !d3.event.altKey && !d3.event.metaKey)
            {
                switch (String.fromCharCode(d3.event.keyCode)) {
                    case "C": keyc = !keyc; break;
                    case "S": keys = !keys; break;
                    case "T": keyt = !keyt; break;
                    case "R": keyr = !keyr; break;
                    case "X": keyx = !keyx; break;
                    case "D": keyd = !keyd; break;
                    case "L": keyl = !keyl; break;
                    case "M": keym = !keym; break;
                    case "H": keyh = !keyh; break;
                    case "1": key1 = !key1; break;
                    case "2": key2 = !key2; break;
                    case "3": key3 = !key3; break;
                    case "0": key0 = !key0; break;
                }

                path.style("display", function(d) {
                    var flag  = vis_by_type(d.source.type)&&vis_by_type(d.target.type)&&vis_by_node_score(d.source.score)&&vis_by_node_score(d.target.score)&&vis_by_link_score(d.score);
                    linkedByIndex[d.source.index + "," + d.target.index] = flag;
                    return flag?"inline":"none";});
                node.style("display", function(d) {
                    return (key0||hasConnections(d))&&vis_by_type(d.type)&&vis_by_node_score(d.score)?"inline":"none";});

//                text.style("display", function(d) {
//                    return (key0||hasConnections(d))&&vis_by_type(d.type)&&vis_by_node_score(d.score)?"inline":"none";});

                if (highlight_node !== null)
                {
                    if ((key0||hasConnections(highlight_node))&&vis_by_type(highlight_node.type)&&vis_by_node_score(highlight_node.score)) {
                        if (focus_node!==null) set_focus(focus_node);
                        set_highlight(highlight_node);
                    }
                    else {exit_highlight();}
                }

            }
        }

    });

    function vis_by_type(type)
    {
        switch (type) {
            case "circle": return keyc;
            case "square": return keys;
            case "triangle-up": return keyt;
            case "diamond": return keyr;
            case "cross": return keyx;
            case "triangle-down": return keyd;
            default: return true;
        }
    }
    function vis_by_node_score(score)
    {
        if (isNumber(score))
        {
            if (score>=0.666) return keyh;
            else if (score>=0.333) return keym;
            else if (score>=0) return keyl;
        }
        return true;
    }

    function vis_by_link_score(score)
    {
        if (isNumber(score))
        {
            if (score>=0.666) return key3;
            else if (score>=0.333) return key2;
            else if (score>=0) return key1;
        }
        return true;
    }

    function isNumber(n) {
        return !isNaN(parseFloat(n)) && isFinite(n);
    }
</script>































































<%--<script>--%>
    <%--var margin = {top: -5, right: -5, bottom: -5, left: -5};--%>
    <%--var width = 500 - margin.left - margin.right,--%>
            <%--height = 400 - margin.top - margin.bottom;--%>


    <%--var color = d3.scale.category20();--%>

    <%--var force = d3.layout.force()--%>
            <%--.charge(-200)--%>
            <%--.linkDistance(50)--%>
            <%--.size([width + margin.left + margin.right, height + margin.top + margin.bottom]);--%>

    <%--var zoom = d3.behavior.zoom()--%>
            <%--.scaleExtent([1, 10])--%>
            <%--.on("zoom", zoomed);--%>

    <%--var drag = d3.behavior.drag()--%>
            <%--.origin(function(d) { return d; })--%>
            <%--.on("dragstart", dragstarted)--%>
            <%--.on("drag", dragged)--%>
            <%--.on("dragend", dragended);--%>

    <%--var svg = d3.select("#map").append("svg")--%>
            <%--.attr("width", width + margin.left + margin.right)--%>
            <%--.attr("height", height + margin.top + margin.bottom)--%>
            <%--.append("g")--%>
            <%--.attr("transform", "translate(" + margin.left + "," + margin.right + ")")--%>
            <%--.call(zoom);--%>
<%--//            .on("dblclick.zoom", null);--%>

    <%--var rect = svg.append("rect")--%>
            <%--.attr("width", width)--%>
            <%--.attr("height", height)--%>
            <%--.style("fill", "none")--%>
            <%--.style("pointer-events", "all");--%>

    <%--var container = svg.append("g");--%>

    <%--container.append("svg:defs").selectAll("marker").data(["end"])--%>
            <%--.enter().append("svg:marker")--%>
            <%--.attr("id", String)--%>
            <%--.attr("viewBox", "0 -5 10 10")--%>
            <%--.attr("refX", 15)--%>
            <%--.attr("refY", -1.5)--%>
            <%--.attr("markerWidth", 6)--%>
            <%--.attr("markerHeight", 6)--%>
            <%--.attr("orient", "auto")--%>
            <%--.append("svg:path")--%>
            <%--.attr("d", "M0,-5L10,0L0,5");--%>


    <%--d3.json('/resources/js/testd3.json', function(error, graph){--%>
        <%--force.nodes(graph.nodes).links(graph.links).start();--%>


        <%--var path = container.append("svg:g").selectAll("path")--%>
                <%--.data(force.links()).enter()--%>
                <%--.append("svg:path")--%>
                <%--.attr("class", "link")--%>
                <%--.attr("marker-end", "url(#end)");--%>

        <%--var node = container.append("g").selectAll('.node').data(graph.nodes)--%>
                <%--.enter().append("circle")--%>
                <%--.attr("class", "node")--%>
                <%--.attr("r", 5)--%>
                <%--.style('fill', function(d){ return color(d.group); })--%>
                <%--.call(force.drag());--%>

        <%--node.append('title').text(function(d){ return d.name; })--%>

        <%--force.on("tick", function(){--%>
            <%--path.attr("d", function(d){--%>
                <%--var dx = d.target.x - d.source.x,--%>
                        <%--dy = d.target.y - d.source.y,--%>
                        <%--dr = Math.sqrt(dx*dx + dy*dy);--%>

                <%--return "M" +--%>
                        <%--d.source.x + "," +--%>
                        <%--d.source.y + "A" +--%>
                        <%--dr + "," + dr + " 0 0,1 " +--%>
                        <%--d.target.x + "," +--%>
                        <%--d.target.y;--%>
            <%--}).style("stroke", function(d){ return color(d.value*10) });--%>

            <%--node.attr("transform", function(d) {--%>
                <%--return "translate(" + d.x + "," + d.y + ")"; });--%>
<%--//            node.attr("cx", function(d){ return d.x; })--%>
<%--//                    .attr("cy", function(d){ return d.y; });--%>
        <%--})--%>
    <%--});--%>


    <%--function zoomed() {--%>
        <%--svg.attr("transform", "translate(" + zoom.translate() + ")scale(" + zoom.scale() + ")");--%>
    <%--}--%>

    <%--function dragstarted(d) {--%>
        <%--d3.event.sourceEvent.stopPropagation();--%>

        <%--d3.select(this).classed("dragging", true);--%>
        <%--force.start();--%>
    <%--}--%>

    <%--function dragged(d) {--%>
        <%--d3.select(this).attr("cx", d.x = d3.event.x).attr("cy", d.y = d3.event.y);--%>
    <%--}--%>

    <%--function dragended(d) {--%>
        <%--d3.select(this).classed("dragging", false);--%>
    <%--}--%>
<%--</script>--%>

<%--<script>--%>
    <%--var margin = {top: -5, right: -5, bottom: -5, left: -5};--%>
    <%--var width = 500 - margin.left - margin.right,--%>
            <%--height = 400 - margin.top - margin.bottom;--%>

    <%--var active = d3.select(null);--%>

    <%--var color = d3.scale.category20();--%>

    <%--var force = d3.layout.force()--%>
            <%--.charge(-200)--%>
            <%--.linkDistance(50)--%>
            <%--.size([width + margin.left + margin.right, height + margin.top + margin.bottom]);--%>

    <%--var zoom = d3.behavior.zoom()--%>
            <%--.scaleExtent([1, 10])--%>
            <%--.on("zoom", zoomed);--%>

    <%--var drag = d3.behavior.drag()--%>
            <%--.origin(function(d) { return d; })--%>
            <%--.on("dragstart", dragstarted)--%>
            <%--.on("drag", dragged)--%>
            <%--.on("dragend", dragended);--%>


    <%--var svg = d3.select("#map").append("svg")--%>
            <%--.attr("width", width + margin.left + margin.right)--%>
            <%--.attr("height", height + margin.top + margin.bottom)--%>
            <%--.append("g")--%>
            <%--.attr("transform", "translate(" + margin.left + "," + margin.right + ")")--%>
            <%--.call(zoom)--%>
            <%--.on("dblclick.zoom", null);--%>

    <%--var rect = svg.append("rect")--%>
            <%--.attr("width", width)--%>
            <%--.attr("height", height)--%>
            <%--.style("fill", "none")--%>
            <%--.style("pointer-events", "all");--%>

    <%--var container = svg.append("g");--%>

    <%--d3.json('/resources/js/testd3.json', function(error, graph) {--%>
        <%--force--%>
                <%--.nodes(graph.nodes)--%>
                <%--.links(graph.links)--%>
                <%--.start();--%>


        <%--var link = container.append("g")--%>
                <%--.attr("class", "links")--%>
                <%--.selectAll(".link")--%>
                <%--.data(graph.links)--%>
                <%--.enter().append("line")--%>
                <%--.attr("class", "link")--%>
                <%--.style("stroke-width", function (d) {--%>
                    <%--return Math.sqrt(d.value);--%>
                <%--});--%>

        <%--var node = container.append("g")--%>
                <%--.attr("class", "nodes")--%>
                <%--.selectAll(".node")--%>
                <%--.data(graph.nodes)--%>
                <%--.enter().append("g")--%>
                <%--.attr("class", "node")--%>
                <%--.attr("cx", function (d) {--%>
                    <%--return d.x;--%>
                <%--})--%>
                <%--.attr("cy", function (d) {--%>
                    <%--return d.y;--%>
                <%--})--%>
                <%--.call(drag);--%>


        <%--node.append("circle")--%>
                <%--.attr("r", function (d) {--%>
                    <%--return d.weight * 2 + 12;--%>
                <%--})--%>
                <%--.style("fill", function (d) {--%>
                    <%--return color(1 / d.rating);--%>
                <%--});--%>


        <%--force.on("tick", function () {--%>
            <%--link.attr("x1", function (d) {--%>
                        <%--return d.source.x;--%>
                    <%--})--%>
                    <%--.attr("y1", function (d) {--%>
                        <%--return d.source.y;--%>
                    <%--})--%>
                    <%--.attr("x2", function (d) {--%>
                        <%--return d.target.x;--%>
                    <%--})--%>
                    <%--.attr("y2", function (d) {--%>
                        <%--return d.target.y;--%>
                    <%--});--%>

            <%--node.attr("transform", function (d) {--%>
                <%--return "translate(" + d.x + "," + d.y + ")";--%>
            <%--});--%>
        <%--});--%>



        <%--var linkedByIndex = {};--%>
        <%--graph.links.forEach(function (d) {--%>
            <%--linkedByIndex[d.source.index + "," + d.target.index] = 1;--%>
        <%--});--%>

        <%--function isConnected(a, b){--%>
            <%--return linkedByIndex[a.index + "," + b.index] || linkedByIndex[b.index + "," + a.index];--%>
        <%--}--%>

        <%--node.on("mouseover", function (d) {--%>
                    <%--node.classed("node-active", function (o) {--%>
                        <%--thisOpacity = isConnected(d, o) ? true : false;--%>
                        <%--this.setAttribute('fill-opacity', thisOpacity);--%>
                        <%--return thisOpacity;--%>
                    <%--});--%>

                    <%--link.classed("link-active", function (o) {--%>
                        <%--return o.source === d || o.target === d ? true : false;--%>
                    <%--});--%>

                    <%--d3.select(this).classed("node-active", true);--%>
                    <%--d3.select(this).select("circle").transition()--%>
                            <%--.duration(750)--%>
                            <%--.attr("r", (d.weight * 2 + 12) * 1.5);--%>
                <%--})--%>
                <%--.on("mouseout", function (d) {--%>
                    <%--node.classed("node-active", false);--%>
                    <%--link.classed("link-active", false);--%>

                    <%--d3.select(this).select("circle").transition()--%>
                            <%--.duration(750)--%>
                            <%--.attr("r", d.weight * 2 + 12);--%>
                <%--});--%>



        <%--function interpolateZoom(translate, scale){--%>
            <%--return d3.transition().duration(750).tween("zoom", function(){--%>
                <%--var iTranslate = d3.interpolate(zoom.translate(), translate),--%>
                        <%--iScale = d3.interpolate(zoom.scale(), scale);--%>
                <%--return function(t){--%>
                    <%--zoom.scale(iScale(t))--%>
                            <%--.translate(iTranslate(t));--%>
                    <%--zoomed();--%>
                <%--}--%>
            <%--});--%>
        <%--}--%>

        <%--function zoomClick()--%>
        <%--{--%>
            <%--var clicked = d3.event.target;--%>
            <%--var direction = -1;--%>
            <%--var factor = 0.2;--%>
            <%--var target_zoom = 1;--%>
            <%--var center = [width/2, height/2];--%>
            <%--var extent = zoom.scaleExtent();--%>
            <%--var translate = zoom.translate();--%>
            <%--var translate0 = [];--%>
            <%--var l = [];--%>
            <%--var view = {x:translate[0], y:translate[1], k:zoom.scale()};--%>

            <%--console.log(translate);--%>

            <%--if(d3.event.defaultPrevented)return;--%>

            <%--if(active.node() == clicked){ // if clicks on the same node--%>
                <%--active.classed("active",false);--%>
                <%--active = d3.select(null);--%>
                <%--direction = 1;--%>
            <%--}--%>

            <%--active.classed("active",false);--%>
            <%--active = d3.select(clicked).classed("active",true);--%>

            <%--target_zoom = zoom.scale() *(1+factor*direction);--%>

            <%--if(target_zoom < extent[0] || target_zoom > extent[1])return;--%>

            <%--translate0 = [(center[0] - view.x) / view.k, (center[1] - view.y) / view.k];--%>
            <%--view.k = target_zoom;--%>

            <%--l = [translate0[0]*view.k+view.x, translate0[1]*view.k+view.y];--%>
            <%--view.x += center[0] - l[0];--%>
            <%--view.y += center[1] - l[1];--%>

            <%--interpolateZoom([view.x, view.y], view.k);--%>
        <%--}--%>

        <%--node.on("click", zoomClick);--%>
    <%--});--%>

    <%--function dottype(d) {--%>
        <%--d.x = +d.x;--%>
        <%--d.y = +d.y;--%>
        <%--return d;--%>
    <%--}--%>

    <%--function zoomed() {--%>
        <%--svg.attr("transform", "translate(" + zoom.translate() + ")scale(" + zoom.scale() + ")");--%>
    <%--}--%>

    <%--function dragstarted(d) {--%>
        <%--d3.event.sourceEvent.stopPropagation();--%>

        <%--d3.select(this).classed("dragging", true);--%>
        <%--force.start();--%>
    <%--}--%>

    <%--function dragged(d) {--%>
        <%--d3.select(this).attr("cx", d.x = d3.event.x).attr("cy", d.y = d3.event.y);--%>
    <%--}--%>

    <%--function dragended(d) {--%>
        <%--d3.select(this).classed("dragging", false);--%>
    <%--}--%>

<%--</script>--%>
</body>
</html>
