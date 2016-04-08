<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>hello</title>
    <link rel="stylesheet" href="/resources/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/resources/css/bootstrap-theme.min.css" />
    <link rel="stylesheet" href="/resources/css/helloworld.css" />
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <script src="/resources/js/jquery-1.12.1.js"></script>
    <script src="/resources/js/d3.js"></script>
    <script src="/resources/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function(){
            $(".sb-search-submit").hover(function(){
                $(this).css("background-color","0CA2F9");
            }, function(){
                $(this).css("background-color","#00c3f9");
            })
        });

        $("#myTabs a").click(function (e) {
            e.preventDefault();
            $(this).tab('show');
        });
    </script>

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

<!--header-->
<div class="header">
    <div class="container">
        <div class="logo">
            <h1>
                <a href="#">
                    <span class="glyphicon glyphicon-education" aria-hidden="true"></span> RelSearch
                    <i>Search everything you want</i>
                </a>
            </h1>
        </div>

        <div class="search">
            <!-- start search -->
            <input class="sb-search-input" placeholder="输入关键字" type="search" name="keyword" id="search" />
            <input class="sb-search-submit" type="button" value="" />
            <span class="sb-icon-search"></span>
            <div class="clearfix"></div>
            <!-- end search -->
        </div>
    </div>
</div>
<!--//header-->


<%--<p><%=request.getParameter("keyword")%></p>--%>
<div class="search-result-box row">
    <div id="show-info-box" class="col-lg-6">
        <div class="flip-container" ontouchstart="this.classList.toggle('hover');">
            <div class="flipper">
                <div class="front row">
                        <div class="col-lg-3">
                            <img src="/resources/images/jiaweihan.jpeg" id="avatar"/>
                        </div>
                        <div class="col-lg-9">
                            <div class="profile-box">
                                <h1 id="authorname">JiaWei Han（韩家炜）</h1>
                                <p id="dept"><span class="glyphicon glyphicon-tags"></span>&nbsp;Department of Computer Science, University of Illinois at Urbana-Champaign</p>
                                <p id="dept-position"> <span class="glyphicon glyphicon-briefcase"></span>&nbsp;Professor</p>
                                <p><span class="glyphicon glyphicon-pencil"></span><a href="#" id="email">&nbsp;Email: hanj@cs.uiuc.edu</a></p>
                                <p><span class="glyphicon glyphicon-link"></span>
                                    <a  id="homepage" href="http://hanj.cs.illinois.edu/" target="_blank">&nbsp;Personal Homepage: http://hanj.cs.illinois.edu/</a>
                                </p>
                                <br />
                                <p><span class="glyphicon glyphicon-eye-open"></span>&nbsp;Research Interests</p>

                                <div id="research-interest" style="display:inline;">
                                    <span class="badge alert-info">Data Mining</span>
                                    <span class="badge alert-info">Information Network</span>
                                    <span class="badge alert-info">Machine Learning</span>
                                    <span class="badge alert-info">Large Database</span>
                                    <span class="badge alert-info">Big Data</span>
                                    <span class="badge alert-info">Knowledge Discovery</span>
                                </div>
                            </div>
                        </div>
                        <div class="clearfix"></div>
                </div>

                <div class="back">
                    <h1>I am back.</h1>
                </div>
            </div>
        </div>
    </div>
    <div id="graph-container" class="col-lg-6" ></div>
    <div class="clearfix"></div>
</div>

<!-- flip script -->
<script>
    $('.flip-container').dblclick(function(){
        var a = $(this).find('.flipper');
        console.log(this);
        if(a.hasClass('flipped'))a.removeClass('flipped');
        else a.addClass('flipped');

        return true;
    });
</script>
<!-- flip script end -->


<script>
    //    var w = window.innerWidth;
    //    var h = window.innerHeight;
    var margin = {top: -5, right: -5, bottom: -5, left: -5};
    var w = 600;
    var h = 450;

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
            //            .size([w,h]);
            .size([w + margin.left + margin.right, h + margin.top + margin.bottom]);


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

    var svg = d3.select("#graph-container").append("svg");
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
                .attr("marker-end", "url(#end)");



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
//            var dcx = (window.innerWidth/2-d.x*zoom.scale());
//            var dcy = (window.innerHeight/2-d.y*zoom.scale());
            var dcx = ((w + margin.left + margin.right)/2-d.x*zoom.scale());
            var dcy = ((h + margin.top + margin.bottom)/2-d.y*zoom.scale());
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
//            var width = window.innerWidth, height = window.innerHeight;
            var width = w + margin.left + margin.right, height = h + margin.top + margin.bottom;
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



<div class="container">
    <div class="paper-box-result">
        <div class="row">
            <div class="col-lg-2">
                <div class="tabs-left">
                    <ul id="myTabs" class="nav nav-tabs">
                        <li class="active">
                            <a href="#papers" data-toggle="tab">
                                <span class="glyphicon glyphicon-paperclip" aria-hidden="true"></span>
                                <b> Papers</b>
                            </a>
                        </li>
                        <li>
                            <a href="#cites" data-toggle="tab">
                                <span class="glyphicon glyphicon-link"></span>
                                <b> Cite Relationship</b>
                            </a>
                        </li>

                        <li>
                            <a href="#videos" data-toggle="tab">
                                <span class="glyphicon glyphicon-film" aria-hidden="true"></span>
                                <b> Videos</b>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-10">
                <div class="tab-content">
                    <div class="tab-pane fade in active" id="papers">
                        <c:forEach items="${paperList}" var="paper">
                            <div class="paper-box">
                                <span class="badge pull-left alert-success">867</span>
                                <h4>&nbsp;${paper.title}</h4>
                                <p>${paper.authors}</p>
                                <p class="text-info">${paper.conference}</p>
                                <span class="glyphicon glyphicon-book"></span><a href="${paper.url}" target="_blank"> ${paper.url}</a>
                            </div>
                        </c:forEach>



                    </div>
                    <div class="tab-pane fade" id="cites">Secondo sed ac orci quis tortor imperdiet venenatis. Duis elementum auctor accumsan.
                        Aliquam in felis sit amet augue.</div>
                    <div class="tab-pane fade" id="videos">Videos</div>
                </div>
            </div>
        </div>
    </div>
</div>

<%--<div class="footer">--%>
    <%--<p>finish</p>--%>
<%--</div>--%>

</body>
</html>
