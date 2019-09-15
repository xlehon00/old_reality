<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="MapSVG is the best WordPress mapping plugin: create interactive vector maps, Google maps, Image maps - with directory, search and filters.">

    <title>MapSVG - best WordPress mapping plugin | Interactive Vector Maps, Google maps, Image maps</title>

    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/select2.min.css" rel="stylesheet">
    <link href="/css/landing-page.css" rel="stylesheet">
    <link href="/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <script>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

        ga('create', 'UA-73140091-1', 'auto');
        ga('send', 'pageview');

    </script>


</head>

<body id="main-page">

<div id="maps-list" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">List of available maps</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-6"></div>
                    <div class="col-sm-6"></div>
                </div>
            </div>
            <!--<div class="modal-footer">-->
            <!--<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>-->
            <!--<button type="button" class="btn btn-primary">Save changes</button>-->
            <!--</div>-->
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<!-- Navigation -->
<nav class="navbar navbar-default topnav" role="navigation">
    <div class="container topnav">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand topnav" href="/" style="display: inline-block"></a>
        </div>
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav navbar-right">
                <li>
                    <a href="/">WordPress plugin</a>
                </li>
                <li>
                    <a href="/add-ons/gallery">Add-ons</a>
                </li>
                <li>
                    <a href="/jquery/">jQuery plugin</a>
                </li>
                <li>
                    <a href="/maps/">Maps</a>
                </li>
                <li>
                    <a href="/tutorials/">Tutorials</a>
                </li>
                <li>
                    <a href="/documentation/">Documentation</a>
                </li>
                <li>
                    <a href="/changelog/">Changelog</a>
                </li>
                <li>
                    <a href="http://codecanyon.net/item/mapsvg-interactive-vector-maps-and-floorplans/2547255/support?ref=RomanCode">Support</a>
                </li>
            </ul>
        </div>
        <!-- /.navbar-collapse -->
    </div>
    <!-- /.container -->
</nav>

<!-- Header -->
<a name="about"></a>



<div class="intro-header">

    <div class="container" style="position: relative;">

        <div class="row">
            <div class="col-lg-12">

                <div style="text-align: center; margin-top: 50px;">
                    <img src="/img/logo.svg" style="width: 250px; height: auto;"/>
                </div>

                <div class="intro-message" style="padding: 40px 0;">
                    <div id="moto" style="font-family: ProximaNova; font-weight: 200; text-transform: none; ">
                        The ultimate WordPress mapping solution.
                    </div>
                    <h3>Interactive SVG vector maps, Google Maps, Image maps.</h3>

                    <!--<hr class="intro-divider">-->
                    <ul class="list-inline intro-social-buttons">
                        <li>
                            <a href="http://codecanyon.net/item/mapsvg-interactive-vector-maps/2547255?ref=RomanCode"  class="btn btn-default btn-transparent btn-lg"><i class="fa fa-shopping-cart fa-fw"></i>  <span class="network-name">Purchase $36</span></a>
                        </li>
                        <li>
                            <form enctype="multipart/form-data" action="http://demo.mapsvg.com" method="post" id="cbs-register-2">
                                <input name="cbs_action" type="hidden" id="cbs_action_2" value="cbs_demo">

                                <button name="cbs_register" type="submit" style="padding: 13px 18px;" class="btn btn-default btn-lg btn-transparent btn-transparent-white network-name">WordPress Admin Demo</button>

                            </form>
                        </li>

                    </ul>
                </div>
            </div>
        </div>
    </div>
    <!-- /.container -->
</div>
<!-- /.intro-header -->


<div style="background-color: #f5f5f5;">
    <div class="container" style="padding: 30px 0; text-align: center;">
        <!--<h3 class="text-center lead" style="margin-top: 0; color: #999;font-size: 16px;">Best-selling WordPress map plugin on CodeCanyon since 2012</h3>-->
        <div class="purchased-by">
            <div style="font-size: 16px; color: #aaa; line-height: 40px;">
                Used in projects for:
            </div>
            <img src="/img/logos/microsoft.svg" style="height: 40px;"/>
            <img src="/img/logos/cebit.svg" style="height: 40px;"/>
            <img src="/img/logos/moneygram.svg" style="height: 40px;"/>
            <!--<div style="font-size: 16px; color: #aaa; line-height: 40px;">-->
                <!--and 4000+  other customers-->
            <!--</div>-->
        </div>
    </div>
</div>

<div id="topline"></div>

<div id="mmm" class="hide-markers content-section-111" style="margin: 0; width: 50%; float: left; height: 100vh;">
    <div id="mapsvg-4"></div>
</div>


<div id="test" style="padding-left: 50%;">
    <div style="padding: 0 30px; text-align: center;">
        <div class="mapsvg-feature-section active">


            <p class="lead" style="text-align: center; margin-bottom: 150px;">
                MapSVG is a WordPress map plugin<br /> which is able create all 3 kinds of maps:<br /><br />
                <em>1. Interactive vector maps (SVG)</em><br />
                <em>2. Google maps</em><br />
                <em>3. Image maps</em>
            </p>

            <div class="centered">
                <h2 class="section-title col-xs-9 col-sm-4">one</h2>
                <h3 class="section-subtitle">Interactive SVG vector maps</h3>
            </div>

            <p class="lead">
                Turn any SVG vector image into an interactive map with MapSVG WordPress plugin.
            </p>
            <p class="lead">
                SVG maps of countries included in the WordPress plugin:
            <!-- MAPS -->
            <select class="form-control" style="width: 100%;font-size:12px;" tabindex="-1" aria-hidden="true" id="mapsvg-select-map">
                <option value="">...</option>
                <option data-map="/maps/geo-calibrated/iceland.svg">/geo-calibrated/iceland.svg</option>
                <option data-map="/maps/geo-calibrated/uruguay.svg">/geo-calibrated/uruguay.svg</option>
                <option data-map="/maps/geo-calibrated/rwanda.svg">/geo-calibrated/rwanda.svg</option>
                <option data-map="/maps/geo-calibrated/czech-republic.svg">/geo-calibrated/czech-republic.svg</option>
                <option data-map="/maps/geo-calibrated/kyrgyzstan.svg">/geo-calibrated/kyrgyzstan.svg</option>
                <option data-map="/maps/geo-calibrated/belgium.svg">/geo-calibrated/belgium.svg</option>
                <option data-map="/maps/geo-calibrated/usa-full.svg">/geo-calibrated/usa-full.svg</option>
                <option data-map="/maps/geo-calibrated/italy.svg">/geo-calibrated/italy.svg</option>
                <option data-map="/maps/geo-calibrated/qatar.svg">/geo-calibrated/qatar.svg</option>
                <option data-map="/maps/geo-calibrated/andorra.svg">/geo-calibrated/andorra.svg</option>
                <option data-map="/maps/geo-calibrated/france-new.svg">/geo-calibrated/france-new.svg</option>
                <option data-map="/maps/geo-calibrated/france-departments.svg">/geo-calibrated/france-departments.svg</option>
                <option data-map="/maps/geo-calibrated/israel.svg">/geo-calibrated/israel.svg</option>
                <option data-map="/maps/geo-calibrated/jamaica.svg">/geo-calibrated/jamaica.svg</option>
                <option data-map="/maps/geo-calibrated/uzbekistan.svg">/geo-calibrated/uzbekistan.svg</option>
                <option data-map="/maps/geo-calibrated/netherlands.svg">/geo-calibrated/netherlands.svg</option>
                <option data-map="/maps/geo-calibrated/moldova.svg">/geo-calibrated/moldova.svg</option>
                <option data-map="/maps/geo-calibrated/pakistan.svg">/geo-calibrated/pakistan.svg</option>
                <option data-map="/maps/geo-calibrated/bolivia.svg">/geo-calibrated/bolivia.svg</option>
                <option data-map="/maps/geo-calibrated/slovakia.svg">/geo-calibrated/slovakia.svg</option>
                <option data-map="/maps/geo-calibrated/portugal-regions.svg">/geo-calibrated/portugal-regions.svg</option>
                <option data-map="/maps/geo-calibrated/macedonia.svg">/geo-calibrated/macedonia.svg</option>
                <option data-map="/maps/geo-calibrated/bosnia-herzegovina.svg">/geo-calibrated/bosnia-herzegovina.svg</option>
                <option data-map="/maps/geo-calibrated/bangladesh.svg">/geo-calibrated/bangladesh.svg</option>
                <option data-map="/maps/geo-calibrated/hong-kong.svg">/geo-calibrated/hong-kong.svg</option>
                <option data-map="/maps/geo-calibrated/vietnam.svg">/geo-calibrated/vietnam.svg</option>
                <option data-map="/maps/geo-calibrated/romania.svg">/geo-calibrated/romania.svg</option>
                <option data-map="/maps/geo-calibrated/cyprus.svg">/geo-calibrated/cyprus.svg</option>
                <option data-map="/maps/geo-calibrated/portugal.svg">/geo-calibrated/portugal.svg</option>
                <option data-map="/maps/geo-calibrated/cameroon.svg">/geo-calibrated/cameroon.svg</option>
                <option data-map="/maps/geo-calibrated/ireland.svg">/geo-calibrated/ireland.svg</option>
                <option data-map="/maps/geo-calibrated/spain.svg">/geo-calibrated/spain.svg</option>
                <option data-map="/maps/geo-calibrated/cambodia.svg">/geo-calibrated/cambodia.svg</option>
                <option data-map="/maps/geo-calibrated/indonesia.svg">/geo-calibrated/indonesia.svg</option>
                <option data-map="/maps/geo-calibrated/austria.svg">/geo-calibrated/austria.svg</option>
                <option data-map="/maps/geo-calibrated/kenya.svg">/geo-calibrated/kenya.svg</option>
                <option data-map="/maps/geo-calibrated/south-korea.svg">/geo-calibrated/south-korea.svg</option>
                <option data-map="/maps/geo-calibrated/bahrain.svg">/geo-calibrated/bahrain.svg</option>
                <option data-map="/maps/geo-calibrated/nigeria.svg">/geo-calibrated/nigeria.svg</option>
                <option data-map="/maps/geo-calibrated/tajikistan.svg">/geo-calibrated/tajikistan.svg</option>
                <option data-map="/maps/geo-calibrated/burundi.svg">/geo-calibrated/burundi.svg</option>
                <option data-map="/maps/geo-calibrated/colombia.svg">/geo-calibrated/colombia.svg</option>
                <option data-map="/maps/geo-calibrated/thailand.svg">/geo-calibrated/thailand.svg</option>
                <option data-map="/maps/geo-calibrated/armenia.svg">/geo-calibrated/armenia.svg</option>
                <option data-map="/maps/geo-calibrated/bahamas.svg">/geo-calibrated/bahamas.svg</option>
                <option data-map="/maps/geo-calibrated/chile.svg">/geo-calibrated/chile.svg</option>
                <option data-map="/maps/geo-calibrated/switzerland.svg">/geo-calibrated/switzerland.svg</option>
                <option data-map="/maps/geo-calibrated/mali.svg">/geo-calibrated/mali.svg</option>
                <option data-map="/maps/geo-calibrated/faroe-islands.svg">/geo-calibrated/faroe-islands.svg</option>
                <option data-map="/maps/geo-calibrated/costa-rica.svg">/geo-calibrated/costa-rica.svg</option>
                <option data-map="/maps/geo-calibrated/morocco.svg">/geo-calibrated/morocco.svg</option>
                <option data-map="/maps/geo-calibrated/new-zealand.svg">/geo-calibrated/new-zealand.svg</option>
                <option data-map="/maps/geo-calibrated/palestine.svg">/geo-calibrated/palestine.svg</option>
                <option data-map="/maps/geo-calibrated/malaysia.svg">/geo-calibrated/malaysia.svg</option>
                <option data-map="/maps/geo-calibrated/dominican-republic.svg">/geo-calibrated/dominican-republic.svg</option>
                <option data-map="/maps/geo-calibrated/cape-verde.svg">/geo-calibrated/cape-verde.svg</option>
                <option data-map="/maps/geo-calibrated/liechtenstein.svg">/geo-calibrated/liechtenstein.svg</option>
                <option data-map="/maps/geo-calibrated/el-salvador.svg">/geo-calibrated/el-salvador.svg</option>
                <option data-map="/maps/geo-calibrated/angola.svg">/geo-calibrated/angola.svg</option>
                <option data-map="/maps/geo-calibrated/united-kingdom-counties.svg">/geo-calibrated/united-kingdom-counties.svg</option>
                <option data-map="/maps/geo-calibrated/central-african-republic.svg">/geo-calibrated/central-african-republic.svg</option>
                <option data-map="/maps/geo-calibrated/iran.svg">/geo-calibrated/iran.svg</option>
                <option data-map="/maps/geo-calibrated/world.svg">/geo-calibrated/world.svg</option>
                <option data-map="/maps/geo-calibrated/finland.svg">/geo-calibrated/finland.svg</option>
                <option data-map="/maps/geo-calibrated/venezuela.svg">/geo-calibrated/venezuela.svg</option>
                <option data-map="/maps/geo-calibrated/slovenia.svg">/geo-calibrated/slovenia.svg</option>
                <option data-map="/maps/geo-calibrated/japan.svg">/geo-calibrated/japan.svg</option>
                <option data-map="/maps/geo-calibrated/mexico.svg">/geo-calibrated/mexico.svg</option>
                <option data-map="/maps/geo-calibrated/paraguay.svg">/geo-calibrated/paraguay.svg</option>
                <option data-map="/maps/geo-calibrated/nepal.svg">/geo-calibrated/nepal.svg</option>
                <option data-map="/maps/geo-calibrated/laos.svg">/geo-calibrated/laos.svg</option>
                <option data-map="/maps/geo-calibrated/united-kingdom.svg">/geo-calibrated/united-kingdom.svg</option>
                <option data-map="/maps/geo-calibrated/russia.svg">/geo-calibrated/russia.svg</option>
                <option data-map="/maps/geo-calibrated/luxembourg.svg">/geo-calibrated/luxembourg.svg</option>
                <option data-map="/maps/geo-calibrated/bulgaria.svg">/geo-calibrated/bulgaria.svg</option>
                <option data-map="/maps/geo-calibrated/greece.svg">/geo-calibrated/greece.svg</option>
                <option data-map="/maps/geo-calibrated/guatemala.svg">/geo-calibrated/guatemala.svg</option>
                <option data-map="/maps/geo-calibrated/singapore.svg">/geo-calibrated/singapore.svg</option>
                <option data-map="/maps/geo-calibrated/haiti.svg">/geo-calibrated/haiti.svg</option>
                <option data-map="/maps/geo-calibrated/serbia-without-kosovo.svg">/geo-calibrated/serbia-without-kosovo.svg</option>
                <option data-map="/maps/geo-calibrated/chad.svg">/geo-calibrated/chad.svg</option>
                <option data-map="/maps/geo-calibrated/estonia.svg">/geo-calibrated/estonia.svg</option>
                <option data-map="/maps/geo-calibrated/australia.svg">/geo-calibrated/australia.svg</option>
                <option data-map="/maps/geo-calibrated/philippines.svg">/geo-calibrated/philippines.svg</option>
                <option data-map="/maps/geo-calibrated/congo.svg">/geo-calibrated/congo.svg</option>
                <option data-map="/maps/geo-calibrated/latvia.svg">/geo-calibrated/latvia.svg</option>
                <option data-map="/maps/geo-calibrated/guinea.svg">/geo-calibrated/guinea.svg</option>
                <option data-map="/maps/geo-calibrated/united-arab-emirates.svg">/geo-calibrated/united-arab-emirates.svg</option>
                <option data-map="/maps/geo-calibrated/georgia.svg">/geo-calibrated/georgia.svg</option>
                <option data-map="/maps/geo-calibrated/brunei-darussalam.svg">/geo-calibrated/brunei-darussalam.svg</option>
                <option data-map="/maps/geo-calibrated/oman.svg">/geo-calibrated/oman.svg</option>
                <option data-map="/maps/geo-calibrated/san-marino.svg">/geo-calibrated/san-marino.svg</option>
                <option data-map="/maps/geo-calibrated/norway.svg">/geo-calibrated/norway.svg</option>
                <option data-map="/maps/geo-calibrated/taiwan.svg">/geo-calibrated/taiwan.svg</option>
                <option data-map="/maps/geo-calibrated/kosovo.svg">/geo-calibrated/kosovo.svg</option>
                <option data-map="/maps/geo-calibrated/serbia.svg">/geo-calibrated/serbia.svg</option>
                <option data-map="/maps/geo-calibrated/azerbaijan.svg">/geo-calibrated/azerbaijan.svg</option>
                <option data-map="/maps/geo-calibrated/china.svg">/geo-calibrated/china.svg</option>
                <option data-map="/maps/geo-calibrated/south-africa.svg">/geo-calibrated/south-africa.svg</option>
                <option data-map="/maps/geo-calibrated/cuba.svg">/geo-calibrated/cuba.svg</option>
                <option data-map="/maps/geo-calibrated/ecuador.svg">/geo-calibrated/ecuador.svg</option>
                <option data-map="/maps/geo-calibrated/sri-lanka.svg">/geo-calibrated/sri-lanka.svg</option>
                <option data-map="/maps/geo-calibrated/kazakhstan.svg">/geo-calibrated/kazakhstan.svg</option>
                <option data-map="/maps/geo-calibrated/spain-provinces.svg">/geo-calibrated/spain-provinces.svg</option>
                <option data-map="/maps/geo-calibrated/panama.svg">/geo-calibrated/panama.svg</option>
                <option data-map="/maps/geo-calibrated/sweden.svg">/geo-calibrated/sweden.svg</option>
                <option data-map="/maps/geo-calibrated/germany.svg">/geo-calibrated/germany.svg</option>
                <option data-map="/maps/geo-calibrated/belarus.svg">/geo-calibrated/belarus.svg</option>
                <option data-map="/maps/geo-calibrated/egypt.svg">/geo-calibrated/egypt.svg</option>
                <option data-map="/maps/geo-calibrated/burkina-faso.svg">/geo-calibrated/burkina-faso.svg</option>
                <option data-map="/maps/geo-calibrated/djibouti.svg">/geo-calibrated/djibouti.svg</option>
                <option data-map="/maps/geo-calibrated/canada.svg">/geo-calibrated/canada.svg</option>
                <option data-map="/maps/geo-calibrated/bosnia-herzegovina-2.svg">/geo-calibrated/bosnia-herzegovina-2.svg</option>
                <option data-map="/maps/geo-calibrated/lithuania.svg">/geo-calibrated/lithuania.svg</option>
                <option data-map="/maps/geo-calibrated/hungary.svg">/geo-calibrated/hungary.svg</option>
                <option data-map="/maps/geo-calibrated/saudi-arabia.svg">/geo-calibrated/saudi-arabia.svg</option>
                <option data-map="/maps/geo-calibrated/honduras.svg">/geo-calibrated/honduras.svg</option>
                <option data-map="/maps/geo-calibrated/montenegro.svg">/geo-calibrated/montenegro.svg</option>
                <option data-map="/maps/geo-calibrated/argentina.svg">/geo-calibrated/argentina.svg</option>
                <option data-map="/maps/geo-calibrated/world-low-resolution.svg">/geo-calibrated/world-low-resolution.svg</option>
                <option data-map="/maps/geo-calibrated/denmark.svg">/geo-calibrated/denmark.svg</option>
                <option data-map="/maps/geo-calibrated/usa.svg">/geo-calibrated/usa.svg</option>
                <option data-map="/maps/geo-calibrated/croatia.svg">/geo-calibrated/croatia.svg</option>
                <option data-map="/maps/geo-calibrated/india.svg">/geo-calibrated/india.svg</option>
                <option data-map="/maps/geo-calibrated/congo-dr.svg">/geo-calibrated/congo-dr.svg</option>
                <option data-map="/maps/geo-calibrated/syria.svg">/geo-calibrated/syria.svg</option>
                <option data-map="/maps/geo-calibrated/brazil.svg">/geo-calibrated/brazil.svg</option>
                <option data-map="/maps/geo-calibrated/nicaragua.svg">/geo-calibrated/nicaragua.svg</option>
                <option data-map="/maps/geo-calibrated/yemen.svg">/geo-calibrated/yemen.svg</option>
                <option data-map="/maps/geo-calibrated/uganda.svg">/geo-calibrated/uganda.svg</option>
                <option data-map="/maps/geo-calibrated/turkey.svg">/geo-calibrated/turkey.svg</option>
                <option data-map="/maps/geo-calibrated/poland.svg">/geo-calibrated/poland.svg</option>
                <option data-map="/maps/geo-calibrated/iraq.svg">/geo-calibrated/iraq.svg</option>
                <option data-map="/maps/geo-calibrated/ukraine.svg">/geo-calibrated/ukraine.svg</option>
                <option data-map="/maps/geo-calibrated/malta.svg">/geo-calibrated/malta.svg</option>
                <option data-map="/maps/geo-calibrated/bhutan.svg">/geo-calibrated/bhutan.svg</option>
                <option data-map="/maps/geo-calibrated/myanmar.svg">/geo-calibrated/myanmar.svg</option>
                <option data-map="/maps/geo-calibrated/botswana.svg">/geo-calibrated/botswana.svg</option>
                <option data-map="/maps/not-calibrated/usa/usa-all-counties.svg">/not-calibrated/usa/usa-all-counties.svg</option>
                <option data-map="/maps/not-calibrated/usa/usa-labels.svg">/not-calibrated/usa/usa-labels.svg</option>
                <option data-map="/maps/not-calibrated/usa/usa-canada.svg">/not-calibrated/usa/usa-canada.svg</option>
                <option data-map="/maps/not-calibrated/usa/usa-labels-boxes.svg">/not-calibrated/usa/usa-labels-boxes.svg</option>
                <option data-map="/maps/not-calibrated/usa/usa.svg">/not-calibrated/usa/usa.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ia.svg">/not-calibrated/usa/counties/usa-ia.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-mi.svg">/not-calibrated/usa/counties/usa-mi.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-wy.svg">/not-calibrated/usa/counties/usa-wy.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-wa.svg">/not-calibrated/usa/counties/usa-wa.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ky.svg">/not-calibrated/usa/counties/usa-ky.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-fl.svg">/not-calibrated/usa/counties/usa-fl.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ak.svg">/not-calibrated/usa/counties/usa-ak.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-la.svg">/not-calibrated/usa/counties/usa-la.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-nv.svg">/not-calibrated/usa/counties/usa-nv.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ms.svg">/not-calibrated/usa/counties/usa-ms.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-nj.svg">/not-calibrated/usa/counties/usa-nj.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-tn.svg">/not-calibrated/usa/counties/usa-tn.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-nd.svg">/not-calibrated/usa/counties/usa-nd.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-hi.svg">/not-calibrated/usa/counties/usa-hi.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-mo.svg">/not-calibrated/usa/counties/usa-mo.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ny.svg">/not-calibrated/usa/counties/usa-ny.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-md.svg">/not-calibrated/usa/counties/usa-md.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-or.svg">/not-calibrated/usa/counties/usa-or.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-me.svg">/not-calibrated/usa/counties/usa-me.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-de.svg">/not-calibrated/usa/counties/usa-de.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-id.svg">/not-calibrated/usa/counties/usa-id.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-sc.svg">/not-calibrated/usa/counties/usa-sc.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-sd.svg">/not-calibrated/usa/counties/usa-sd.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-pa.svg">/not-calibrated/usa/counties/usa-pa.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ri.svg">/not-calibrated/usa/counties/usa-ri.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ks.svg">/not-calibrated/usa/counties/usa-ks.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-co.svg">/not-calibrated/usa/counties/usa-co.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ma.svg">/not-calibrated/usa/counties/usa-ma.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-wv.svg">/not-calibrated/usa/counties/usa-wv.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-az.svg">/not-calibrated/usa/counties/usa-az.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-nc.svg">/not-calibrated/usa/counties/usa-nc.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-nh.svg">/not-calibrated/usa/counties/usa-nh.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ct.svg">/not-calibrated/usa/counties/usa-ct.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-oh.svg">/not-calibrated/usa/counties/usa-oh.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ne.svg">/not-calibrated/usa/counties/usa-ne.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-in.svg">/not-calibrated/usa/counties/usa-in.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ca.svg">/not-calibrated/usa/counties/usa-ca.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-nm.svg">/not-calibrated/usa/counties/usa-nm.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-il.svg">/not-calibrated/usa/counties/usa-il.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-wi.svg">/not-calibrated/usa/counties/usa-wi.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-wdc.svg">/not-calibrated/usa/counties/usa-wdc.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-tx.svg">/not-calibrated/usa/counties/usa-tx.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-va.svg">/not-calibrated/usa/counties/usa-va.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ok.svg">/not-calibrated/usa/counties/usa-ok.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-vt.svg">/not-calibrated/usa/counties/usa-vt.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-mn.svg">/not-calibrated/usa/counties/usa-mn.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ut.svg">/not-calibrated/usa/counties/usa-ut.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-mt.svg">/not-calibrated/usa/counties/usa-mt.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ar.svg">/not-calibrated/usa/counties/usa-ar.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-ga.svg">/not-calibrated/usa/counties/usa-ga.svg</option>
                <option data-map="/maps/not-calibrated/usa/counties/usa-al.svg">/not-calibrated/usa/counties/usa-al.svg</option>
                <option data-map="/maps/not-calibrated/usa/usa-labels-full.svg">/not-calibrated/usa/usa-labels-full.svg</option>
            </select>
            </p>

            <p class="lead">
                Also there is a <a href="#" id="mapsvg-show-world-map">World map</a>.
            </p>


            <div id="mapsvg-preview"></div>

            <p class="lead">
                You're free to use your own SVG images: custom maps, floor plans, any image which you want to make interactive.
            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-popovers">
            <p class="lead" style="text-align: center;">
                Show <em>tooltips</em> & <em>pop-ups</em>.<br />
            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-popovers-2">
            <p class="lead" style="text-align: center;">
                Add HTML with custom fields in <em>template editor</em>.
                <img src="/img/templates.png" style="max-width: 100%; margin-top: 20px; border-radius: 4px; box-shadow: 0 0 15px rgba(0,0,0,.2);" />

            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-link">
            <p class="lead" style="text-align: center;">
                Regions of the map can work as links.<br />
            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-disable">
            <p class="lead" style="text-align: center;">
                Disable some regions.
            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-choro">
            <p class="lead" style="text-align: center;">
                Show statistical information with different shades of a color.<br />
                Such kind of map is called "Choropleth map".
            </p>
        </div>


        <div class="mapsvg-feature-section" id="section-directory">
            <p class="lead" style="text-align: center;">
                Show <em>directory</em> with a list of states / provinces / countries near your interactive map.
            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-directory-2">
            <p class="lead" style="text-align: center;">
                Or create a list of objects with custom fields.<br />
                <img src="/img/form-2.png" style="max-width: 100%; margin-top: 20px; border-radius: 4px; box-shadow: 0 0 15px rgba(0,0,0,.2);" />
            </p>
            <p class="lead" style="text-align: center;">
                Possible custom field types: <br />
                <em>text, textarea, radio, checkbox, WordPress post, <br />date, images, status, regions, marker.</em>
            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-markers-1">
            <p class="lead" style="text-align: center;">
                Add <em>markers</em> by entering an address or lat/lon coordinates.
            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-filters">
            <p class="lead" style="text-align: center;">
                Add <em>search</em> and <em>filters</em>.
            </p>
        </div>


        <div class="mapsvg-feature-section" id="section-details">
            <p class="lead" style="text-align: center;">
                Show <em>Details View</em>.
            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-google-1">
            <div class="centered" id="test2">
                <h2 class="section-title col-xs-9 col-sm-4">two</h2>
                <h3 class="section-subtitle">Google Maps</h3>
            </div>


            <p class="lead centered">
                Combine interactive SVG vector map with Google Map.<br />
                Vector maps are positioned on Google Map automatically.
            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-google-2" style="text-align: center;">
            <p class="lead" style="text-align: center;">
                Choose type of Google Map:
            </p>


            <div class="btn-group" data-toggle="buttons" id="google-map-type" style="margin: 0 auto;">
                <label class="btn btn-default active">
                    <input type="radio" name="google-map-type" autocomplete="off" checked value="roadmap"> Roadmap
                </label>
                <label class="btn btn-default">
                    <input type="radio" name="google-map-type" autocomplete="off" value="satellite" > Satellite
                </label>
                <label class="btn btn-default">
                    <input type="radio" name="google-map-type" autocomplete="off" value="terrain"> Terrain
                </label>
                <label class="btn btn-default">
                    <input type="radio" name="google-map-type" autocomplete="off" value="hybrid"> Hybrid
                </label>
            </div>

        </div>

        <div class="mapsvg-feature-section" id="section-airport" style="text-align: center;">
            <p class="lead" style="text-align: center;">
                Draw your artwork in any vector editing software.<br />
                Put it on Google Map.
            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-airport-2" style="text-align: center;">
            <p class="lead" style="text-align: center;">
                Try to scroll & zoom the map! <br />
                Hover the mouse pointer on airport buildings.
            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-groups" style="text-align: center;">
            <p class="lead" style="text-align: center;">
                Add <em>layers visibility toggles</em>.
            </p>
        </div>



        <div class="mapsvg-feature-section" id="section-image-map">
            <div class="centered" >
                <h2 class="section-title col-xs-9 col-sm-4">three</h2>
                <h3 class="section-subtitle">Image maps</h3>
            </div>


            <p class="lead">
                MapSVG has drawing tools which allow you to create
                interactive Image Maps from raster JPEG/PNG images.
                <img src="/img/draw.png" style="max-width: 100%; margin-top: 20px; border-radius: 4px; box-shadow: 0 0 15px rgba(0,0,0,.2);" />

            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-js">
            <div class="centered">
                <h2 class="section-title col-xs-9 col-sm-4">customizations</h2>
                <h3 class="section-subtitle">JavaScript</h3>
            </div>
            <p class="lead">
                MapSVG is extremely extendable with numerous javaScript event handlers.<br />
                <em>Try to click on any building!</em> <br />
                <img src="/img/js.png" style="max-width: 100%; margin-top: 20px; border-radius: 4px; box-shadow: 0 0 15px rgba(0,0,0,.2);" />


            </p>
        </div>

        <div class="mapsvg-feature-section" id="section-css">
            <div class="centered">
                <h2 class="section-title col-xs-9 col-sm-4">customizations</h2>
                <h3 class="section-subtitle">CSS</h3>
            </div>
            <p class="lead centered">
                Fine-tune any styles with built-in CSS editor.<br />
                <img src="/img/css.png" style="max-width: 100%; margin-top: 20px; border-radius: 4px; box-shadow: 0 0 15px rgba(0,0,0,.2);" />
            </p>

        </div>

        <div class="mapsvg-feature-section" id="section-final"></div>


    </div>
</div>

<a  name="contact"></a>
<div id="bottom" class="banner about-author" style="overflow:hidden; color: white;">

    <div class="centered" style="margin-bottom: 40px;">
        <form enctype="multipart/form-data" action="http://demo.mapsvg.com" method="post" id="cbs-register-2">
            <input name="cbs_action" type="hidden" id="cbs_action_3" value="cbs_demo">
            <button name="cbs_register" type="submit" class="btn btn-default btn-lg btn-transparent btn-transparent-white network-name">WordPress Admin Demo</button>
        </form>
    </div>


    <div class="container centered">
        <ul class="list-inline intro-social-buttons" style="margin-bottom: 50px;">
            <li>
                <a href="http://codecanyon.net/item/mapsvg-interactive-vector-maps/2547255?ref=RomanCode"  class="btn btn-default btn-transparent btn-lg"><i class="fa fa-shopping-cart fa-fw"></i>  <span class="network-name">Purchase MapSVG WordPress interactive maps plugin $36</span></a>
            </li>
        </ul>
        <h2 class="section-title col-xs-9 col-sm-4">need help?</h2>
        <h3 class="section-subtitle">Reliable support</h3>
        <div class="row">
            <div class="col-sm-6 text-right">
                <img class="authour-avatar" src="img/author2.jpg" style=""/>
            </div>
            <div class="col-sm-6 text-left">
                <p class="lead" style="color: white;">
                    <b>Roman Stepanov</b>
                    <br />
                    Author of MapSVG WordPress interactive vector maps plugin<br />
                    <img  src="/img/elite.svg" style="display: inline-block;width: 28px; vertical-align: middle;margin-top: 0px;margin-bottom: 4px;"> Envato Elite Author<br />
                    <br />
                    Programming <i>since 1998</i>.
                    <br />
                    Developing MapSVG <i>since 2011</i>.
                    <br />
                    <br />
                    Feel free to <a href="http://codecanyon.net/item/mapsvg-interactive-vector-maps-and-floorplans/2547255/support?ref=RomanCode">contact me</a> in case of any questions.
                    <br />
                    I'm happy to help.
                </p>
            </div>
        </div>

        <br><br>



    </div>
    <!-- /.container -->

</div>
<!-- /.banner -->

<link rel='stylesheet' id='mapsvg-css'  href='http://mapsvg.com/blog/wp-content/plugins/mapsvg/css/mapsvg.css?ver=3.3.26' type='text/css' media='all' />
<link rel='stylesheet' id='nanoscroller-css'  href='http://mapsvg.com/blog/wp-content/plugins/mapsvg/css/nanoscroller.css?ver=4.9.4' type='text/css' media='all' />


<script>
    var ajaxurl = "http://mapsvg.com/blog/wp-admin/admin-ajax.php";
</script>

<script src="/js/jquery.js"></script>
<script src="/js/bootstrap.min.js"></script>
<!--<script src="/js/c.js"></script>-->
<!--<script src="/js/jquery.mousewheel.min.js"></script>-->
<script src="/js/typeahead.bundle.min.js"></script>
<!--<script src="/js/select2.min.js"></script>-->
<script src="//js.maxmind.com/js/apis/geoip2/v2.1/geoip2.js" type="text/javascript"></script>
<!--<script src="/js/mapsvg-gallery.js"></script>-->

<script type='text/javascript' src='http://mapsvg.com/blog/wp-content/plugins/mapsvg/js/jquery.mousewheel.min.js?ver=3.0.6'></script>
<script type='text/javascript' src='http://mapsvg.com/blog/wp-content/plugins/mapsvg/js/handlebars.js?ver=4.0.2'></script>
<script type='text/javascript' src='http://mapsvg.com/blog/wp-content/plugins/mapsvg/js/handlebars-helpers.js?ver=3.3.26'></script>
<script type='text/javascript'>
    /* <![CDATA[ */
    var mapsvg_paths = {"root":"\/blog\/wp-content\/plugins\/mapsvg\/","templates":"\/blog\/wp-content\/plugins\/mapsvg\/js\/mapsvg-admin\/templates\/","maps":"\/blog\/wp-content\/plugins\/mapsvg\/maps\/","uploads":"\/blog\/wp-content\/uploads\/mapsvg\/"};
    /* ]]> */
</script>
<script type='text/javascript' src='http://mapsvg.com/blog/wp-content/plugins/mapsvg/js/mapsvg.min.js?v=4.1.1'></script>
<script type='text/javascript' src='http://mapsvg.com/blog/wp-content/plugins/mapsvg/js/select2.min.js'></script>
<script type='text/javascript' src='http://mapsvg.com/blog/wp-content/plugins/mapsvg/js/mapsvg-admin/form.mapsvg.js'></script>
<script type='text/javascript' src='http://mapsvg.com/blog/wp-content/plugins/mapsvg/js/typeahead.bundle.min.js?ver=1.0'></script>
<script type='text/javascript' src='http://mapsvg.com/blog/wp-content/plugins/mapsvg/js/mapsvg-admin/database-service.js?ver=3.3.26'></script>
<script type='text/javascript' src='http://mapsvg.com/blog/wp-content/plugins/mapsvg/js/jquery.nanoscroller.min.js?ver=0.8.7'></script>
<script type="text/javascript">

    jQuery(document).ready(function(){MapSVG.version = '4.1.0';
        var mapsvg_options = {markerLastID: 0,regionLastID: 0,dataLastID: 1,disableAll: false,width: 640,height: 689,lockAspectRatio: true,padding: {top: 0,left: 0,right: 0,bottom: 0},maxWidth: null,maxHeight: null,minWidth: null,minHeight: null,loadingText: "Loading map...",colorsIgnore: false,colors: {baseDefault: "#000000",background: "#ffffff",selected: 30,hover: 18,directory: "#fafafa",status: {'0': "#ddd"},base: "#e06565",stroke: "#f7f7f7",detailsView: "rgba(255,255,255,0.9)"},regions: {'US-AK': {id: "US-AK",'id_no_spaces': "US-AK",title: "Alaska",data: {id: "US-AK",'region_title': "Alaska",status: "1",'status_text': null,images: null,description: null,choro: "33",'id_no_spaces': "US-AK",title: "Alaska",fill: null}},'US-AL': {id: "US-AL",'id_no_spaces': "US-AL",title: "Alabama",data: {id: "US-AL",'region_title': "Alabama",status: "1",'status_text': null,images: null,description: null,choro: "49",'id_no_spaces': "US-AL",title: "Alabama",fill: null}},'US-AR': {id: "US-AR",'id_no_spaces': "US-AR",title: "Arkansas",data: {id: "US-AR",'region_title': "Arkansas",status: "1",'status_text': null,images: null,description: null,choro: "45",'id_no_spaces': "US-AR",title: "Arkansas",fill: null}},'US-AZ': {id: "US-AZ",'id_no_spaces': "US-AZ",title: "Arizona",data: {id: "US-AZ",'region_title': "Arizona",status: "1",'status_text': null,images: null,description: null,choro: "26",'id_no_spaces': "US-AZ",title: "Arizona",fill: null}},'US-CA': {id: "US-CA",'id_no_spaces': "US-CA",title: "California",data: {id: "US-CA",'region_title': "California",status: "1",'status_text': null,images: null,description: null,choro: "44",'id_no_spaces': "US-CA",title: "California",fill: null}},'US-CO': {id: "US-CO",'id_no_spaces': "US-CO",title: "Colorado",data: {id: "US-CO",'region_title': "Colorado",status: "1",'status_text': null,images: null,description: null,choro: "41",'id_no_spaces': "US-CO",title: "Colorado",fill: null}},'US-CT': {id: "US-CT",'id_no_spaces': "US-CT",title: "Connecticut",data: {id: "US-CT",'region_title': "Connecticut",status: "1",'status_text': null,images: null,description: null,choro: "21",'id_no_spaces': "US-CT",title: "Connecticut",fill: null}},'US-DC': {id: "US-DC",'id_no_spaces': "US-DC",title: "Washington, DC",data: {id: "US-DC",'region_title': "Washington, DC",status: "1",'status_text': null,images: null,description: null,choro: "31",'id_no_spaces': "US-DC",title: "Washington, DC",fill: null}},'US-DE': {id: "US-DE",'id_no_spaces': "US-DE",title: "Delaware",data: {id: "US-DE",'region_title': "Delaware",status: "1",'status_text': null,images: null,description: null,choro: "40",'id_no_spaces': "US-DE",title: "Delaware",fill: null}},'US-FL': {id: "US-FL",'id_no_spaces': "US-FL",title: "Florida",data: {id: "US-FL",'region_title': "Florida",status: "1",'status_text': null,images: null,description: null,choro: "7",'id_no_spaces': "US-FL",title: "Florida",fill: null}},'US-GA': {id: "US-GA",'id_no_spaces': "US-GA",title: "Georgia",data: {id: "US-GA",'region_title': "Georgia",status: "1",'status_text': null,images: null,description: null,choro: "15",'id_no_spaces': "US-GA",title: "Georgia",fill: null}},'US-HI': {id: "US-HI",'id_no_spaces': "US-HI",title: "Hawaii",data: {id: "US-HI",'region_title': "Hawaii",status: "1",'status_text': null,images: null,description: null,choro: "3",'id_no_spaces': "US-HI",title: "Hawaii",fill: null}},'US-IA': {id: "US-IA",'id_no_spaces': "US-IA",title: "Iowa",data: {id: "US-IA",'region_title': "Iowa",status: "1",'status_text': null,images: null,description: null,choro: "19",'id_no_spaces': "US-IA",title: "Iowa",fill: null}},'US-ID': {id: "US-ID",'id_no_spaces': "US-ID",title: "Idaho",data: {id: "US-ID",'region_title': "Idaho",status: "1",'status_text': null,images: null,description: null,choro: "36",'id_no_spaces': "US-ID",title: "Idaho",fill: null}},'US-IL': {id: "US-IL",'id_no_spaces': "US-IL",title: "Illinois",data: {id: "US-IL",'region_title': "Illinois",status: "1",'status_text': null,images: null,description: null,choro: "22",'id_no_spaces': "US-IL",title: "Illinois",fill: null}},'US-IN': {id: "US-IN",'id_no_spaces': "US-IN",title: "Indiana",data: {id: "US-IN",'region_title': "Indiana",status: "1",'status_text': null,images: null,description: null,choro: "51",'id_no_spaces': "US-IN",title: "Indiana",fill: null}},'US-KS': {id: "US-KS",'id_no_spaces': "US-KS",title: "Kansas",data: {id: "US-KS",'region_title': "Kansas",status: "1",'status_text': null,images: null,description: null,choro: "38",'id_no_spaces': "US-KS",title: "Kansas",fill: null}},'US-KY': {id: "US-KY",'id_no_spaces': "US-KY",title: "Kentucky",data: {id: "US-KY",'region_title': "Kentucky",status: "1",'status_text': null,images: null,description: null,choro: "33",'id_no_spaces': "US-KY",title: "Kentucky",fill: null}},'US-LA': {id: "US-LA",'id_no_spaces': "US-LA",title: "Louisiana",data: {id: "US-LA",'region_title': "Louisiana",status: "1",'status_text': "Enabled",images: [{thumbnail: "http://mapsvg.com/blog/wp-content/uploads/2018/04/french-quarter-557458_640-150x150.jpg",medium: "http://mapsvg.com/blog/wp-content/uploads/2018/04/french-quarter-557458_640-300x200.jpg",full: "http://mapsvg.com/blog/wp-content/uploads/2018/04/french-quarter-557458_640.jpg"}],description: "<p>\n  <b>Louisiana</b> is a state in the southeastern region of the United States. It is the 31st in size and the 25th most populous of the 50 United States. Louisiana's capital is Baton Rouge and its largest city is New Orleans. It is the only state in the U.S. with political subdivisions termed parishes, which are the local government's equivalent to counties. The largest parish by population is East Baton Rouge Parish, and the largest by total area is Plaquemines. Louisiana is bordered by Arkansas to the north, Mississippi to the east, Texas to the west, and the Gulf of Mexico to the south.\n</p>\n<p>\nMuch of the state's lands were formed from sediment washed down the Mississippi River, leaving enormous deltas and vast areas of coastal marsh and swamp.[10][self-published source] These contain a rich southern biota; typical examples include birds such as ibis and egrets. There are also many species of tree frogs, and fish such as sturgeon and paddlefish. In more elevated areas, fire is a natural process in the landscape, and has produced extensive areas of longleaf pine forest and wet savannas. These support an exceptionally large number of plant species, including many species of orchids and carnivorous plants. Louisiana has more Native American tribes than any other southern state, including four that are federally recognized, ten that are state recognized, and four that have not yet received recognition.\n</p>  ",choro: "2",'id_no_spaces': "US-LA",title: "Louisiana",fill: null}},'US-MA': {id: "US-MA",'id_no_spaces': "US-MA",title: "Massachusetts",data: {id: "US-MA",'region_title': "Massachusetts",status: "1",'status_text': null,images: null,description: null,choro: "11",'id_no_spaces': "US-MA",title: "Massachusetts",fill: null}},'US-MD': {id: "US-MD",'id_no_spaces': "US-MD",title: "Maryland",data: {id: "US-MD",'region_title': "Maryland",status: "1",'status_text': null,images: null,description: null,choro: "51",'id_no_spaces': "US-MD",title: "Maryland",fill: null}},'US-ME': {id: "US-ME",'id_no_spaces': "US-ME",title: "Maine",data: {id: "US-ME",'region_title': "Maine",status: "1",'status_text': null,images: null,description: null,choro: "14",'id_no_spaces': "US-ME",title: "Maine",fill: null}},'US-MI': {id: "US-MI",'id_no_spaces': "US-MI",title: "Michigan",data: {id: "US-MI",'region_title': "Michigan",status: "1",'status_text': null,images: null,description: null,choro: "22",'id_no_spaces': "US-MI",title: "Michigan",fill: null}},'US-MN': {id: "US-MN",'id_no_spaces': "US-MN",title: "Minnesota",data: {id: "US-MN",'region_title': "Minnesota",status: "1",'status_text': null,images: null,description: null,choro: "15",'id_no_spaces': "US-MN",title: "Minnesota",fill: null}},'US-MO': {id: "US-MO",'id_no_spaces': "US-MO",title: "Missouri",data: {id: "US-MO",'region_title': "Missouri",status: "1",'status_text': null,images: null,description: null,choro: "8",'id_no_spaces': "US-MO",title: "Missouri",fill: null}},'US-MS': {id: "US-MS",'id_no_spaces': "US-MS",title: "Mississippi",data: {id: "US-MS",'region_title': "Mississippi",status: "1",'status_text': null,images: null,description: null,choro: "44",'id_no_spaces': "US-MS",title: "Mississippi",fill: null}},'US-MT': {id: "US-MT",'id_no_spaces': "US-MT",title: "Montana",data: {id: "US-MT",'region_title': "Montana",status: "1",'status_text': "Enabled",images: [{thumbnail: "http://mapsvg.com/blog/wp-content/uploads/2018/04/landscape-2268775_640-150x150.jpg",medium: "http://mapsvg.com/blog/wp-content/uploads/2018/04/landscape-2268775_640-300x200.jpg",full: "http://mapsvg.com/blog/wp-content/uploads/2018/04/landscape-2268775_640.jpg"}],description: "<p><b>Montana</b> is the 4th largest in area, the 8th least populous, and the 3rd most sparsely populated of the\n  50 U.S. states. The western third of Montana contains numerous\n  mountain ranges. Smaller island ranges are found throughout the state.\n  In total, 77 named ranges are part of the Rocky Mountains. \n  The eastern half of Montana is characterized by western prairie terrain \n  and badlands.\n</p>\n<p>\nThe economy is primarily based on agriculture, including ranching\n  and cereal grain farming. Other significant economic resources include oil, \n  gas, coal, hard rock mining, and lumber. The state's fastest-growing sector is \n  tourism. The health care, service, and government sectors also are significant \n  to the state's economy. Millions of tourists annually visit Glacier National \n  Park, the Little Bighorn Battlefield National Monument, and Yellowstone \n  National Park.\n</p>",choro: "43",'id_no_spaces': "US-MT",title: "Montana",fill: null}},'US-NC': {id: "US-NC",'id_no_spaces': "US-NC",title: "North Carolina",data: {id: "US-NC",'region_title': "North Carolina",status: "1",'status_text': null,images: null,description: null,choro: "31",'id_no_spaces': "US-NC",title: "North Carolina",fill: null}},'US-ND': {id: "US-ND",'id_no_spaces': "US-ND",title: "North Dakota",data: {id: "US-ND",'region_title': "North Dakota",status: "1",'status_text': null,images: null,description: null,choro: "25",'id_no_spaces': "US-ND",title: "North Dakota",fill: null}},'US-NE': {id: "US-NE",'id_no_spaces': "US-NE",title: "Nebraska",data: {id: "US-NE",'region_title': "Nebraska",status: "1",'status_text': null,images: null,description: null,choro: "33",'id_no_spaces': "US-NE",title: "Nebraska",fill: null}},'US-NH': {id: "US-NH",'id_no_spaces': "US-NH",title: "New Hampshire",data: {id: "US-NH",'region_title': "New Hampshire",status: "1",'status_text': null,images: null,description: null,choro: "36",'id_no_spaces': "US-NH",title: "New Hampshire",fill: null}},'US-NJ': {id: "US-NJ",'id_no_spaces': "US-NJ",title: "New Jersey",data: {id: "US-NJ",'region_title': "New Jersey",status: "1",'status_text': null,images: null,description: null,choro: "32",'id_no_spaces': "US-NJ",title: "New Jersey",fill: null}},'US-NM': {id: "US-NM",'id_no_spaces': "US-NM",title: "New Mexico",data: {id: "US-NM",'region_title': "New Mexico",status: "1",'status_text': null,images: null,description: null,choro: "51",'id_no_spaces': "US-NM",title: "New Mexico",fill: null}},'US-NV': {id: "US-NV",'id_no_spaces': "US-NV",title: "Nevada",data: {id: "US-NV",'region_title': "Nevada",status: "1",'status_text': null,images: null,description: null,choro: "3",'id_no_spaces': "US-NV",title: "Nevada",fill: null}},'US-NY': {id: "US-NY",'id_no_spaces': "US-NY",title: "New York",data: {id: "US-NY",'region_title': "New York",status: "1",'status_text': null,images: null,description: null,choro: "17",'id_no_spaces': "US-NY",title: "New York",fill: null}},'US-OH': {id: "US-OH",'id_no_spaces': "US-OH",title: "Ohio",data: {id: "US-OH",'region_title': "Ohio",status: "1",'status_text': null,images: null,description: null,choro: "24",'id_no_spaces': "US-OH",title: "Ohio",fill: null}},'US-OK': {id: "US-OK",'id_no_spaces': "US-OK",title: "Oklahoma",data: {id: "US-OK",'region_title': "Oklahoma",status: "1",'status_text': null,images: null,description: null,choro: "16",'id_no_spaces': "US-OK",title: "Oklahoma",fill: null}},'US-OR': {id: "US-OR",'id_no_spaces': "US-OR",title: "Oregon",data: {id: "US-OR",'region_title': "Oregon",status: "1",'status_text': null,images: null,description: null,choro: "8",'id_no_spaces': "US-OR",title: "Oregon",fill: null}},'US-PA': {id: "US-PA",'id_no_spaces': "US-PA",title: "Pennsylvania",data: {id: "US-PA",'region_title': "Pennsylvania",status: "1",'status_text': null,images: null,description: null,choro: "44",'id_no_spaces': "US-PA",title: "Pennsylvania",fill: null}},'US-RI': {id: "US-RI",'id_no_spaces': "US-RI",title: "Rhode Island",data: {id: "US-RI",'region_title': "Rhode Island",status: "1",'status_text': null,images: null,description: null,choro: "40",'id_no_spaces': "US-RI",title: "Rhode Island",fill: null}},'US-SC': {id: "US-SC",'id_no_spaces': "US-SC",title: "South Carolina",data: {id: "US-SC",'region_title': "South Carolina",status: "1",'status_text': null,images: null,description: null,choro: "20",'id_no_spaces': "US-SC",title: "South Carolina",fill: null}},'US-SD': {id: "US-SD",'id_no_spaces': "US-SD",title: "South Dakota",data: {id: "US-SD",'region_title': "South Dakota",status: "1",'status_text': null,images: null,description: null,choro: "27",'id_no_spaces': "US-SD",title: "South Dakota",fill: null}},'US-TN': {id: "US-TN",'id_no_spaces': "US-TN",title: "Tennessee",data: {id: "US-TN",'region_title': "Tennessee",status: "1",'status_text': null,images: null,description: null,choro: "27",'id_no_spaces': "US-TN",title: "Tennessee",fill: null}},'US-TX': {id: "US-TX",'id_no_spaces': "US-TX",title: "Texas",data: {id: "US-TX",'region_title': "Texas",status: "1",'status_text': null,images: null,description: null,choro: "51",'id_no_spaces': "US-TX",title: "Texas",fill: null}},'US-UT': {id: "US-UT",'id_no_spaces': "US-UT",title: "Utah",data: {id: "US-UT",'region_title': "Utah",status: "1",'status_text': null,images: null,description: null,choro: "21",'id_no_spaces': "US-UT",title: "Utah",fill: null}},'US-VA': {id: "US-VA",'id_no_spaces': "US-VA",title: "Virginia",data: {id: "US-VA",'region_title': "Virginia",status: "1",'status_text': null,images: null,description: null,choro: "2",'id_no_spaces': "US-VA",title: "Virginia",fill: null}},'US-VT': {id: "US-VT",'id_no_spaces': "US-VT",title: "Vermont",data: {id: "US-VT",'region_title': "Vermont",status: "1",'status_text': null,images: null,description: null,choro: "48",'id_no_spaces': "US-VT",title: "Vermont",fill: null}},'US-WA': {id: "US-WA",'id_no_spaces': "US-WA",title: "Washington",data: {id: "US-WA",'region_title': "Washington",status: "1",'status_text': null,images: null,description: null,choro: "28",'id_no_spaces': "US-WA",title: "Washington",fill: null}},'US-WI': {id: "US-WI",'id_no_spaces': "US-WI",title: "Wisconsin",data: {id: "US-WI",'region_title': "Wisconsin",status: "1",'status_text': null,images: null,description: null,choro: "49",'id_no_spaces': "US-WI",title: "Wisconsin",fill: null}},'US-WV': {id: "US-WV",'id_no_spaces': "US-WV",title: "West Virginia",data: {id: "US-WV",'region_title': "West Virginia",status: "1",'status_text': null,images: null,description: null,choro: "6",'id_no_spaces': "US-WV",title: "West Virginia",fill: null}},'US-WY': {id: "US-WY",'id_no_spaces': "US-WY",title: "Wyoming",data: {id: "US-WY",'region_title': "Wyoming",status: "1",'status_text': null,images: null,description: null,choro: "34",'id_no_spaces': "US-WY",title: "Wyoming",fill: null}}},viewBox: [477,260.79921875,593,638.4015625],cursor: "default",menuOnClick: null,beforeLoad: null,zoom: {on: false,limit: [0,10],delta: 2,buttons: {on: true,location: "right"},mousewheel: true},scroll: {on: false,limit: false,background: false,spacebar: false},responsive: true,tooltips: {on: true,position: "bottom-right",template: ""},popovers: {on: false,position: "top",template: "",centerOn: true,width: 300,maxWidth: 50,maxHeight: 50,resetViewboxOnClose: true},multiSelect: false,regionStatuses: {'0': {label: "Disabled",value: "0",color: "#ddd",disabled: true},'1': {label: "Enabled",value: "1",color: "",disabled: false}},events: {afterLoad: "function(){\n this.viewBoxSetBySize($(window).width()/2, $(window).height());\n}",beforeLoad: null,databaseLoaded: null,'click.region': null,'mouseover.region': null,'mouseout.region': null,'click.marker': null,'mouseover.marker': null,'mouseout.marker': null,'click.directoryItem': null,'mouseover.directoryItem': null,'mouseout.directoryItem': null,'shown.popover': null,'shown.detailsView': null,'closed.popover': null,'closed.detailsView': null},templates: {popoverRegion: "Hey, <em>this</em> is <b>{{title}}</b>!\n{{#if images}}\n  <img src=\"{{images.0.full}}\" style=\"margin: 10px 0;\"/>\n{{/if}}       \n{{#if description}}\n  {{{description}}}\n{{/if}}",popoverMarker: "",tooltipRegion: "{{title}}",tooltipMarker: "",directoryItem: "{{#if title}}\n  {{title}}\n{{/if}}\n{{#unless title}}\n  <img src={{images.0.thumbnail}} width=\"40\" />\n  {{name}}\n{{/unless}}",detailsView: "<div class=\"centered\">\n<img class=\"mapsvg-user-avatar\" src=\"{{images.[0].full}}\" />\n<div class=\"mapsvg-user-info\">  \n\t<b>{{name}}</b><br />\n  <b>Location:</b>\n    {{#each regions}}\n        {{title}}{{#unless @last}},{{/unless}}\n    {{/each}}\n</div>\n</div>\n\n<h1>User details</h1>\n\n<p><strong>Pellentesque habitant morbi tristique</strong> senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. <em>Aenean ultricies mi vitae est.</em> Mauris placerat eleifend leo. Quisque sit amet est et sapien ullamcorper pharetra. Vestibulum erat wisi, condimentum sed, <code>commodo vitae</code>, ornare sit amet, wisi. Aenean fermentum, elit eget tincidunt condimentum, eros ipsum rutrum orci, sagittis tempus lacus enim ac dui. <a href=\"#\">Donec non enim</a> in turpis pulvinar facilisis. Ut felis.</p>\n\n<h2>Header Level 2</h2>\n\n<ol>\n   <li>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</li>\n   <li>Aliquam tincidunt mauris eu risus.</li>\n</ol>\n\n<blockquote><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus magna. Cras in mi at felis aliquet congue. Ut a est eget ligula molestie gravida. Curabitur massa. Donec eleifend, libero at sagittis mollis, tellus est malesuada tellus, at luctus turpis elit sit amet quam. Vivamus pretium ornare est.</p></blockquote>\n\n<h3>Header Level 3</h3>\n\n<ul>\n   <li>Lorem ipsum dolor sit amet, consectetuer adipiscing elit.</li>\n   <li>Aliquam tincidunt mauris eu risus.</li>\n</ul>\n\n<pre><code>\n#header h1 a {\n  display: block;\n  width: 300px;\n  height: 80px;\n}\n</code></pre>\n",detailsViewRegion: "<img class=\"mapsvg-user-avatar\" src=\"{{photo.[0].full}}\" />\n<div class=\"mapsvg-user-info\">  \n\t<b>{{name}}</b><br />\n    <em>{{job_text}}</em><br />\n\t{{address}}<br />\n\t{{email}}<br /><br />\n  <b>Available for work in states:</b>\n    {{#each regions}}\n        {{title}}{{#unless @last}},{{/unless}}\n    {{/each}}\n</div>\n\n",tooltip: "{{#if isRegion}}<b>{{id}}</b>{{#if title}}: {{title}} {{/if}} {{/if}}",template: "{{#if isMarker}}<b>{{id}}</b>{{/if}}"},gauge: {on: false,labels: {low: "cold",high: "hot"},colors: {lowRGB: {r: 133,g: 56,b: 61,a: 1},highRGB: {r: 255,g: 93,b: 93,a: 1},low: "#85383d",high: "#ff5d5d",diffRGB: {r: 122,g: 37,b: 32,a: 0}},min: 2,max: 51,maxAdjusted: 49},filters: {on: false},menu: {on: false,search: false,customContainer: false,containerId: "",searchPlaceholder: "Search...",searchFallback: false,source: "regions",width: "200px",position: "left",sortBy: "id",sortDirection: "desc",clickActions: {region: "default",marker: "default",directoryItem: {triggerClick: true,showPopover: false,showDetails: false}},detailsViewLocation: "overDirectory",noResultsText: "No results found"},database: {pagination: {on: true,perpage: 30},table: ""},actions: {region: {click: {showDetails: false,showDetailsFor: "region",filterDirectory: true,loadObjects: false,showPopover: false,showPopoverFor: "region",goToLink: false}},marker: {click: {showDetails: false,showPopover: false,goToLink: false}},directoryItem: {click: {showDetails: false,showPopover: false,goToLink: false,selectRegion: true,fireRegionOnClick: true}}},detailsView: {location: "near",containerId: "",width: "100%"},mobileView: {labelMap: "Map",labelList: "List"},googleMaps: {on: false,apiKey: "AIzaSyB6TZWtBHr5P5-aHGNtoL8DvMEqd8MrRw0",loaded: false,center: "auto",type: "roadmap",minZoom: 1},groups: [],floors: [],layersControl: {on: false,position: "top-left",label: "Show on map",expanded: true,maxHeight: "100%"},floorsControl: {on: false,position: "top-left",label: "Floors",expanded: false,maxHeight: "100%"},svgFileVersion: 1,source: "/blog/wp-content/plugins/mapsvg/maps/geo-calibrated/usa.svg",'db_map_id': "4",title: "USA",regionChoroplethField: "choro",disableLinks: null,parameterName: "Object.regions",filtersSchema: [{type: "select",'db_type': "varchar(255)",label: "",name: "",options: [{label: "Alabama",value: "US-AL"},{label: "Alaska",value: "US-AK"},{label: "Arizona",value: "US-AZ"},{label: "Arkansas",value: "US-AR"},{label: "California",value: "US-CA"},{label: "Colorado",value: "US-CO"},{label: "Connecticut",value: "US-CT"},{label: "Delaware",value: "US-DE"},{label: "Florida",value: "US-FL"},{label: "Georgia",value: "US-GA"},{label: "Hawaii",value: "US-HI"},{label: "Idaho",value: "US-ID"},{label: "Illinois",value: "US-IL"},{label: "Indiana",value: "US-IN"},{label: "Iowa",value: "US-IA"},{label: "Kansas",value: "US-KS"},{label: "Kentucky",value: "US-KY"},{label: "Louisiana",value: "US-LA"},{label: "Maine",value: "US-ME"},{label: "Maryland",value: "US-MD"},{label: "Massachusetts",value: "US-MA"},{label: "Michigan",value: "US-MI"},{label: "Minnesota",value: "US-MN"},{label: "Mississippi",value: "US-MS"},{label: "Missouri",value: "US-MO"},{label: "Montana",value: "US-MT"},{label: "Nebraska",value: "US-NE"},{label: "Nevada",value: "US-NV"},{label: "New Hampshire",value: "US-NH"},{label: "New Jersey",value: "US-NJ"},{label: "New Mexico",value: "US-NM"},{label: "New York",value: "US-NY"},{label: "North Carolina",value: "US-NC"},{label: "North Dakota",value: "US-ND"},{label: "Ohio",value: "US-OH"},{label: "Oklahoma",value: "US-OK"},{label: "Oregon",value: "US-OR"},{label: "Pennsylvania",value: "US-PA"},{label: "Rhode Island",value: "US-RI"},{label: "South Carolina",value: "US-SC"},{label: "South Dakota",value: "US-SD"},{label: "Tennessee",value: "US-TN"},{label: "Texas",value: "US-TX"},{label: "Utah",value: "US-UT"},{label: "Vermont",value: "US-VT"},{label: "Virginia",value: "US-VA"},{label: "Washington",value: "US-WA"},{label: "Washington, DC",value: "US-DC"},{label: "West Virginia",value: "US-WV"},{label: "Wisconsin",value: "US-WI"},{label: "Wyoming",value: "US-WY"}],optionsDict: {'US-AL': "Alabama",'US-AK': "Alaska",'US-AZ': "Arizona",'US-AR': "Arkansas",'US-CA': "California",'US-CO': "Colorado",'US-CT': "Connecticut",'US-DE': "Delaware",'US-FL': "Florida",'US-GA': "Georgia",'US-HI': "Hawaii",'US-ID': "Idaho",'US-IL': "Illinois",'US-IN': "Indiana",'US-IA': "Iowa",'US-KS': "Kansas",'US-KY': "Kentucky",'US-LA': "Louisiana",'US-ME': "Maine",'US-MD': "Maryland",'US-MA': "Massachusetts",'US-MI': "Michigan",'US-MN': "Minnesota",'US-MS': "Mississippi",'US-MO': "Missouri",'US-MT': "Montana",'US-NE': "Nebraska",'US-NV': "Nevada",'US-NH': "New Hampshire",'US-NJ': "New Jersey",'US-NM': "New Mexico",'US-NY': "New York",'US-NC': "North Carolina",'US-ND': "North Dakota",'US-OH': "Ohio",'US-OK': "Oklahoma",'US-OR': "Oregon",'US-PA': "Pennsylvania",'US-RI': "Rhode Island",'US-SC': "South Carolina",'US-SD': "South Dakota",'US-TN': "Tennessee",'US-TX': "Texas",'US-UT': "Utah",'US-VT': "Vermont",'US-VA': "Virginia",'US-WA': "Washington",'US-DC': "Washington, DC",'US-WV': "West Virginia",'US-WI': "Wisconsin",'US-WY': "Wyoming"},parameterName: "Object.regions",parameterNameShort: "regions",placeholder: "Choose state...",visible: true}],css: "/* Add your styles here */\n\n.mapsvg-user-avatar {\n  width: 50px;\n  height: 50px;\n  top: 50%;\n  left: 10px;\n  margin-top: -25px;\n  border-radius: 25px;  \n  position: absolute;\n  border: 1px solid #fff;\n}\n.mapsvg-user-info {\n  margin-left: 75px;\n}\n.mapsvg-details-container {\n  text-align: center;\n}\n.mapsvg-details-container .mapsvg-user-avatar {\n  display: block;\n  position: relative;\n  margin: 0 auto;\n  width: 200px;\n  height: 200px;\n  border-radius: 100px;\n  margin: 0 auto;\n  left: auto;\n  top: auto;\n}\n.mapsvg-details-container .mapsvg-user-info {\n  margin: 30px 0 0 0;\n}\n\n\n\n\n\n\n\n",options: {'1': {color: "#ddd"}},markers: []};jQuery.extend( true, mapsvg_options, {svg_file_version: 0} );jQuery("#mapsvg-4").mapSvg(mapsvg_options);});
</script>


    <script>

    $(document).on('ready', function(){
//        $('#mmm').css({
//            position: 'absolute',
//            'z-index': 999999,
//            top: $('#test').offset().top+'px'
//        });
    });

    var sections = {};
    var mapFixed = false;

    $(window).on('scroll.section-1.mapsvg',function(){
        if(!mapFixed && $(window).scrollTop()>=$('#topline').offset().top){
            mapFixed = true;
            $('#mmm').css({
                position: 'fixed',
                'z-index': 2,
                top: '0',
                left: 0
            });
        }else if(mapFixed && $(window).scrollTop()<$('#topline').offset().top){
            mapFixed = false;
            $('#mmm').css({
                position: 'relative'
            });
        }else if(mapFixed && $(window).scrollTop()>=($('body').height()-$('#bottom').outerHeight()-$(window).height())){
            var h = $('#bottom').outerHeight() - ($('body').height() -  ($(window).scrollTop()+$(window).height()));
            $('#mmm').css({
                top: 'auto',
                bottom: h+'px'

            });
        }
    });
    $(window).on('scroll.section-popovers.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-popovers').offset().top-$(window).height()/1.7){
            $('#section-popovers').addClass('active');
            $(window).off('scroll.section-popovers.mapsvg');
            var m = MapSVG.get(0);
            var tx = m.getRegion('US-TX');
            m.showPopover(tx);
            tx.setSelected(true);
            m.getData().$details.addClass('hidden-animate');
        }
    });

    $(window).on('scroll.section-popovers-2.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-popovers-2').offset().top-$(window).height()/1.7){
            $('#section-popovers-2').addClass('active');
            $(window).off('scroll.section-popovers-2.mapsvg');
            var la = MapSVG.get(0).getRegion('US-LA');
            la.setSelected(true);
            MapSVG.get(0).showPopover(la);
        }
    });

    $(window).on('scroll.section-link.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-link').offset().top-$(window).height()/1.7){
            $('#section-link').addClass('active');
            $(window).off('scroll.section-link.mapsvg');
            var m = MapSVG.get(0);
            var tx = m.getRegion('US-KS');
            var temp = m.getData().options.templates.popoverRegion;
            m.update({templates: {popoverRegion: 'Click on this state to open <em>google.com</em>!<br />(link opens in a new tab)'}})
            m.showPopover(tx);
            tx.setSelected(true);
            m.update({templates: {popoverRegion: temp}});
            MapSVG.get(0).setEvents({'click.region': function(e, mapsvg){
                var win = window.open('http://google.com', '_blank');
                win.focus();
            }});
        }
    });


    $(window).on('scroll.section-disable.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-disable').offset().top-$(window).height()/1.7){
            $('#section-disable').addClass('active');
            $(window).off('scroll.section-disable.mapsvg');

            var m = MapSVG.get(0);
            m.setEvents({'click.region': function(){}});
            m.popover.close();
            m.deselectAllRegions();

            m.getRegion('US-CO').setStatus(0);
            m.getRegion('US-WY').setStatus(0);
            m.getRegion('US-ND').setStatus(0);
            m.getRegion('US-SD').setStatus(0);
        }
    });

    $(window).on('scroll.section-choro.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-choro').offset().top-$(window).height()/1.7){
            $('#section-choro').addClass('active');
            $(window).off('scroll.section-choro.mapsvg');

            var m = MapSVG.get(0);
            m.update({gauge: {on: true}});
        }
    });



    $(window).on('scroll.section-directory.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-directory').offset().top-$(window).height()/1.7){
            $(window).off('scroll.section-directory.mapsvg');
            $('#section-directory').addClass('active');
            var m = MapSVG.get(0);
            m.setMenu({on: true});
            m.loadDirectory();
            m.viewBoxSetBySize($(window).width()/2-m.getData().$directory.width(), $(window).height());
        }
    });

    $(window).on('scroll.section-directory-2.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-directory-2').offset().top-$(window).height()/1.7){
            $(window).off('scroll.section-directory-2.mapsvg');
            $('#section-directory-2').addClass('active');
            var m = MapSVG.get(0);
            m.getData().options.menu.source = 'database';
            m.getData().controllers.directory.database = m.database;
            m.loadDirectory();
        }
    });



    $(window).on('scroll.section-markers-1.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-markers-1').offset().top-$(window).height()/1.7){
            $(window).off('scroll.section-markers-1.mapsvg');
            $('#section-markers-1').addClass('active');

//            MapSVG.get(0).popover.close();
            var m = MapSVG.get(0);
            $('#mmm').removeClass('hide-markers');
//            m.markerAdd({geoCoords: [29.761993, -95.366302]});
//            m.markerAdd({geoCoords: [40.730610	-73.935242]});
//            m.markersAdjustPosition();
        }
    });

    $(window).on('scroll.section-filters.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-filters').offset().top-$(window).height()/1.7){
            $(window).off('scroll.section-filters.mapsvg');
            $('#section-filters').addClass('active');
            var m = MapSVG.get(0);
            m.getData().options.filters.on = true;
            m.getData().options.menu.search = true;
            m.getData().controllers.directory.search = true;
            var t = '';
            t    += '<div class="mapsvg-directory-search-wrap-margin" >';
            t    += '<input class="mapsvg-directory-search" placeholder="'+m.getData().options.menu.searchPlaceholder+'" />';
            t    += '</div>';
            m.getData().controllers.directory.view.find('.mapsvg-directory-search-wrap').prepend(t);

            m.getData().controllers.directory.setFilters();

        }
    });

    $(window).on('scroll.section-details.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-details').offset().top-$(window).height()/1.7){
            $(window).off('scroll.section-details.mapsvg');
            $('#section-details').addClass('active');
            var m = MapSVG.get(0);
            m.loadDetailsView(m.database.getLoadedObject(3));
            m.getData().$details.removeClass('hidden-animate');
            m.getData().$details.addClass('near');
            m.getData().$details.css({left: '200px'});
            $('#mapsvg-directory-item-3').addClass('selected');
        }
    });

    $(window).on('scroll.section-google-1.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-google-1').offset().top-$(window).height()/1.7){
            $(window).off('scroll.section-google-1.mapsvg');
            $('#section-google-1').addClass('active');

            if(MapSVG.get(0).detailsController)
                MapSVG.get(0).detailsController.destroy();

            MapSVG.get(0).setGoogleMaps({on: true});
            MapSVG.get(0).setColors({base: 'rgba(224,50,50,0.6)'});
//            MapSVG.get(0).setGauge({colors: {low: 'rgba(122,36,62,0.6)', high: 'rgba(247,73,83,0.7)'}});
            MapSVG.get(0).getData().$map.addClass('translucent');
        }
    });
    $(window).on('scroll.section-google-2.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-google-2').offset().top-$(window).height()/1.7){
            $(window).off('scroll.section-google-2.mapsvg');
            $('#section-google-2').addClass('active');

        }
    });

    $(window).on('scroll.section-airport.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-airport').offset().top-$(window).height()/1.7){
            $(window).off('scroll.section-airport.mapsvg');
            $('#section-airport').addClass('active');
            loadMap(36);
        }
    });

    $(window).on('scroll.section-airport-2.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-airport-2').offset().top-$(window).height()/1.7){
            $(window).off('scroll.section-airport-2.mapsvg');
            $('#section-airport-2').addClass('active');
        }
    });

    $(window).on('scroll.section-groups.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-groups').offset().top-$(window).height()/1.7){
            $(window).off('scroll.section-groups.mapsvg');
            $('#section-groups').addClass('active');
            MapSVG.get(0).setLayersControl({on:true});
        }
    });

    $(window).on('scroll.section-image-map.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-image-map').offset().top-$(window).height()/1.7){
            $(window).off('scroll.section-image-map.mapsvg');
            $('#section-image-map').addClass('active');
            loadMap(8);
        }
    });

    $(window).on('scroll.section-js.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-js').offset().top-$(window).height()/1.7){
            $(window).off('scroll.section-js.mapsvg');
            $('#section-js').addClass('active');
            MapSVG.get(0).setEvents({'click.region': function(e, mapsvg){
                mapsvg.zoomTo(this, 1);
                alert("You clicked "+this.id+"!");
            }});
        }
    });

    $(window).on('scroll.section-css.mapsvg',function(){
        if($(window).scrollTop()>=$('#section-css').offset().top-$(window).height()/1.7){
            $(window).off('scroll.section-css.mapsvg');
            $('#section-css').addClass('active');
            var m = MapSVG.get(0);
            m.setEvents({'click.region': function(){}});
            m.viewBoxReset(true);
            var r = m.getRegion('block_1');
            m.showPopover(r);
            r.setSelected(true);
            m.getData().$popover.addClass('black');
        }
    });

    var loadMap = function (id) {
        if (id) {
            jQuery.get(ajaxurl, {action: "mapsvg_get", id: id}, function (data) {
                MapSVG.get(0).destroy();
                eval('var options = ' + data);
                jQuery('#mapsvg-4').mapSvg(options);
            });
        }
    };

    $('#mapsvg-show-world-map').on('click', function(e){
        e.preventDefault();
       showMap('/blog/wp-content/plugins/mapsvg/maps/geo-calibrated/world.svg');
    });

    $('input[name="google-map-type"]').on('change', function(e){
       var type = $('input[name="google-map-type"]:checked').val();
        MapSVG.get(0).setGoogleMaps({type: type});
    });

    var showMap = function(link){
        var m = $('#mapsvg-preview').mapSvg();
        m && m.destroy && m.destroy();
        $('#mapsvg-preview').mapSvg({
            source: link,
            colors: {
                baseDefault: "#e5e5e5",
                background: "rgba(238,238,238,0)",
                selected: 30,
                hover: 18,
                base: "#a18c8c",
                stroke: "#ffffff"
            },
            zoom: {on:1},
            scroll: {on:1},
            tooltips: {on:1},
            templates: {
                'tooltipRegion': 'id: {{id}} / title: {{title}}'
            }
        });
    };


    $("#mapsvg-select-map").select2().on("select2:select",function(e){
        var link = $(this).find("option:selected").data('map');
        if(!link)
            return false;
        showMap(link);
    });
</script>
<style>
    .centered {
        text-align: center;
    }
    #mmm.hide-markers .mapsvg-marker {
        display: none;
    }
    .mapsvg-feature-section {
        text-align: left;

        margin-top: 60vh;
        margin-left: auto;
        margin-right: auto;
        max-width: 580px;
        opacity: 0.3;
        -webkit-transition: opacity .5s;
        -moz-transition: opacity .5s;
        -ms-transition: opacity .5s;
        -o-transition: opacity .5s;
        transition: opacity .5s;
    }
    .mapsvg-feature-section.active {
        opacity: 1;
    }
    .mapsvg-feature-section:first-child {
        margin-top: 30vh;
    }
    #mmm {
        height: 100vh;
    }
    #mmm .mapsvg-wrap {
        top: 50%;
        transform: translateY(-50%);
    }
    .mapsvg-directory-item img {
        border-radius: 50%;
        margin-right: 7px;
    }

    .section {
        border-radius: 50%;
        margin-right: 7px;
    }
    /* Add your styles here */

    .mapsvg-user-avatar {
        width: 50px;
        height: 50px;
        top: 50%;
        left: 10px;
        margin-top: -25px;
        border-radius: 25px;
        position: absolute;
        border: 1px solid #fff;
    }
    .mapsvg-user-info {
        margin-left: 75px;
    }
    .mapsvg-details-container {
        -webkit-transition: opacity .5s;
        -moz-transition: opacity .5s;
        -ms-transition: opacity .5s;
        -o-transition: opacity .5s;
        transition: opacity .5s;
        opacity: 1;
    }
    .mapsvg-details-container.hidden-animate {
        opacity: 0;
    }

    .mapsvg-details-container .mapsvg-user-avatar {
        display: block;
        position: relative;
        margin: 0 auto;
        width: 200px;
        height: 200px;
        border-radius: 100px;
        margin: 0 auto;
        left: auto;
        top: auto;
    }
    .mapsvg-details-container .mapsvg-user-info {
        margin: 30px 0 0 0;
    }

    .mapsvg-details-container h1,
    .mapsvg-details-container h2,
    .mapsvg-details-container h3,
    .mapsvg-details-container h4 {
        font-family: "ProximaNova";
        font-weight: 100;
    }
    .mapsvg-details-container blockquote {
        padding-left: 18px;
    }
    .mapsvg-details-container blockquote,
    .mapsvg-details-container blockquote p {
        font-size: inherit;
        color: #444;
        font-family: inherit;
        font-weight: inherit;
    }
    .mapsvg-popover.black {
        background-color: rgba(0,0,0,.7);
        font-size: 14px;
        color: white;
        width: 150px !important;
        text-align: center;
    }
    .mapsvg-popover.black:before {
        border-top-color: rgba(0,0,0,.7);
    }
    .translucent .mapsvg-region {
        fill-opacity: 0.8;
    }

    .purchased-by  {
        display: block;
    }
    .purchased-by > * {
        /* display: block; */
        display: inline-block;
        margin-right: 30px;
        float: none;
    }





</style>




</body>
</html>
