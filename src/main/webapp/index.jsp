<%--
  Created by IntelliJ IDEA.
  User: kafaichan
  Date: 2016/3/11
  Time: 4:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="/resources/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/resources/css/bootstrap-theme.min.css" />
    <link rel="stylesheet" href="/resources/css/style.css" />

    <script src="/resources/js/jquery-1.12.1.js"></script>

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

            <div class="clearfix"></div>
        </div>
    </div>
    <!--//header-->


    <!-- banner -->
    <div class="banner">
        <div class="container">

                <!-- start search -->
                <div class="search">
                    <!-- start search -->
                    <form method="post" action="/helloworld">
                        <input class="sb-search-input" placeholder="输入关键字" type="search" name="keyword" id="search" />
                        <input class="sb-search-submit" type="submit" value="" />
                        <span class="sb-icon-search"></span>
                    </form>
                    <div class="clearfix"></div>
                    <!-- end search -->
                </div>

                        <script>
                            $(document).ready(function(){
                                $(".sb-search-submit").hover(function(){
                                    $(this).css("background-color","0CA2F9");
                                }, function(){
                                    $(this).css("background-color","#00c3f9");
                                })
                            });

                        </script>
                <!-- end search -->
            </div>
    </div>
    <!--//banner -->

    <!-- footer -->
    <div class="footer">
        <a href="/testd3">Click To D3.js</a>
        <a href="/split">Click to split</a>
    </div>
    <!-- //footer -->

</body>
</html>
