<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="tei"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns="http://www.w3.org/1999/xhtml" xmlns:util="customfunction">
   
   <!--Old doctype declaration-->
   <!--<xsl:output method="html" version="4.01" encoding="utf-8" indent="yes" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN" />-->

   <!-- New doctype declarationfrom http://stackoverflow.com/questions/6334381/how-to-output-doctype-html-with-xslt-->
   <xsl:output method="html" doctype-system="about:legacy-compat" />

   <!-- <xsl:strip-space elements="*" /> -->
   
   <xsl:include href="settings.xsl" />
   
   <xsl:variable name="fullTitle">
      <xsl:choose>
         <xsl:when test="//tei:titleStmt/tei:title != ''">
            <xsl:value-of select="//tei:titleStmt/tei:title" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>No title specified</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   
   <xsl:variable name="truncatedTitle">
      <xsl:call-template name="truncateText">
         <xsl:with-param name="string" select="$fullTitle" />
         <xsl:with-param name="length" select="40" />
      </xsl:call-template>
   </xsl:variable>
   
   <xsl:variable name="witnesses" select="//tei:witness[@xml:id]" />
   
   <xsl:variable name="numWitnesses" select="count($witnesses)" />
      
   <xsl:template match="/">
     <html lang="en">
         <xsl:call-template name="htmlHead" />
        <body> 
            <xsl:call-template name="mainBanner" />
            <xsl:call-template name="manuscriptArea" />
            
         </body>
      </html>
   </xsl:template>
   
   <xsl:template name="htmlHead">
      <head>
         <title>
            <xsl:value-of select="$truncatedTitle" />
            <xsl:text> -- The Versioning Machine 5.0</xsl:text>
         </title>
         <meta charset="utf-8"/>
         <link rel="stylesheet" type="text/css">
            <xsl:attribute name="href">
               <xsl:value-of select="$cssInclude" />
            </xsl:attribute>
         </link>
         
         
         <!-- JQuery and JQuery UI libraries references -->
         <link rel="stylesheet" type="text/css">
            <xsl:attribute name="href">
               <xsl:value-of select="$cssJQuery-UI" />
            </xsl:attribute>
         </link>
        
         <script type="text/javascript">
            <xsl:attribute name="src">
               <xsl:value-of select="$jsJquery" />
            </xsl:attribute>
         </script>
         <script type="text/javascript">
            <xsl:attribute name="src">
               <xsl:value-of select="$jsJquery-UI" />
            </xsl:attribute>
         </script>
         
         
         <!-- RB: JS and CSS files for the zoom and pan effect -->
         <!-- RB: jquery.panzoom plugin from https://github.com/timmywil/jquery.panzoom -->
         <link rel="stylesheet" type="text/css" href="../../src/panzoom/panzoom.css"></link>
         <script src="../../src/panzoom/jquery.panzoom.min.js" type="text/javascript">//</script>
        
        
         <script type="text/javascript">
            <!-- JS to set up global variable -->
            <xsl:call-template name="jsGlobalSettings" />
            <xsl:call-template name="createTimelinePoints" />
            <xsl:call-template name="createTimelineDurations" />
         </script>
         
         <script type="text/javascript">
            <!-- custom JS file -->
            <xsl:attribute name="src">
               <xsl:value-of select="$jsInclude" />
            </xsl:attribute>
         </script>
      </head>
   </xsl:template>
   
   <xsl:template name="mainBanner">
      <div id="mainBanner">
         <xsl:call-template name="brandingLogo" />
         <xsl:call-template name="headline" />
         <xsl:call-template name="mainControls" />
      </div>
   </xsl:template>
   
   <xsl:template name="brandingLogo">
      <div id="brandingLogo">
         <img id="logo" alt="Powered by the Versioning Machine" src="{$vmLogo}"/>
      </div>
   </xsl:template>
   
   <xsl:template name="headline">
      <div id="headline">
         
         <h1>
            <xsl:value-of select="$truncatedTitle" />
         </h1>
         
      </div>
   </xsl:template>
   
   <xsl:template name="mainControls">
      <nav id="mainControls">
         <ul>
            <li>
               <button id="selectWitness" class="topMenuButton dropdownButton">
                  <xsl:value-of select="count($witnesses)"></xsl:value-of>
                  <xsl:text> Total Versions</xsl:text>
                  <img class="noDisplay" src="{$menuArrowUp}" alt="arrow up"/>
                  <img src="{$menuArrowDown}" alt="arrow down"/>
               </button>
               <!-- RB: version dropdown -->
               <ul>
                  <xsl:attribute name="id">witnessList</xsl:attribute>
                  <xsl:attribute name="class">dropdown notVisible</xsl:attribute>
                  <xsl:call-template name="versionDropdown"/>
               </ul>
            </li>
            <xsl:call-template name="topMenu"/>
         </ul>
     </nav>
      
   </xsl:template>
   
   <xsl:template name="versionDropdown">
     <xsl:for-each select="$witnesses">
                 <li>
                    <xsl:attribute name="data-panelid">
                       <xsl:value-of select="@xml:id"></xsl:value-of>
                    </xsl:attribute>
                   <div>
                      <xsl:attribute name="class">listText</xsl:attribute>
                      
                   <div>
                         <xsl:value-of select="."></xsl:value-of>
                   </div> 
                   
                    <div>
                       <button>
                          <xsl:text>OFF</xsl:text>
                       </button>
                    </div>
                   </div>
                </li>
           </xsl:for-each>
  </xsl:template>
   
  
   <xsl:template name="topMenu">
      <xsl:if test="//tei:l[@n]">
         <li>
            <xsl:attribute name="id">linenumberOnOff</xsl:attribute>
            <xsl:attribute name="title">Clicking this button turns the line numbers on or off.</xsl:attribute>
            <button><xsl:attribute name="class">topMenuButton</xsl:attribute>
                <xsl:text>Line numbers</xsl:text>
            </button>
               
         </li>
      </xsl:if>
         <li>
            <xsl:attribute name="data-panelid">bibPanel</xsl:attribute>
            <xsl:attribute name="title">Clicking this button triggers the bibliographic panel to appear or disappear.</xsl:attribute>
            <button>
               <xsl:attribute name="class">topMenuButton</xsl:attribute>
               <xsl:text>Bibliographic panel</xsl:text>
            </button>
         </li>
         <li>
            <xsl:attribute name="data-panelid">notesPanel</xsl:attribute>
            <xsl:attribute name="title">Clicking this button triggers the notes panel to appear or disappear.</xsl:attribute>
            <button>
               <xsl:attribute name="class">topMenuButton listText</xsl:attribute>
               <xsl:text>Notes panel</xsl:text>
            </button>
         </li>
      <xsl:if test="//tei:notesStmt/tei:note[@type='critIntro']">
            <li>
               <xsl:attribute name="data-panelid">critPanel</xsl:attribute>
               <button>
                  <xsl:attribute name="class">topMenuButton listText</xsl:attribute>
                  <xsl:attribute name="title">Clicking this button triggers the critical introduction panel to appear or disappear.</xsl:attribute>
                  <xsl:text>Critical introduction</xsl:text>
               </button>
            </li>
         </xsl:if>
   </xsl:template>
   
   
   
   <xsl:template name="manuscriptArea">
      <div id="mssArea">
         <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc" />
         <xsl:for-each select="$witnesses">
               <xsl:call-template name="manuscriptPanel">
                  <xsl:with-param name="witID" select="@xml:id" />
               </xsl:call-template>
            </xsl:for-each>
         <xsl:call-template name="notesPanel" />
         
         
         <xsl:for-each select="//tei:facsimile/tei:graphic">
            
            <xsl:call-template name="imageViewer" >
               <xsl:with-param name="imgUrl"><xsl:value-of select="@url"/></xsl:with-param>
               <xsl:with-param name="imgId" select="@xml:id"></xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>
      </div>
   </xsl:template>
   
   <xsl:template name="manuscriptPanel">
      
      <xsl:param name="witID" />
      <!-- RB: added draggable resizeable -->
      <div>
         <xsl:attribute name="class">
            <xsl:text>ui-widget-content ui-resizable panel mssPanel noDisplay</xsl:text>
         </xsl:attribute>
         <xsl:attribute name="id">
            <xsl:value-of select="$witID"></xsl:value-of>
         </xsl:attribute>
         <div class="panelBanner">
            <img class="closePanel" title="Close panel" src="{$closePanelButton}" alt="X (Close panel)" />
            <xsl:text>Witness </xsl:text><xsl:value-of select="$witID"></xsl:value-of>
         </div>
         <div class="mssContent">
            <xsl:if test="//tei:witDetail[@target = concat('#',$witID) and tei:media[@url]]">
               <xsl:call-template name="audioPlayer">
                  <xsl:with-param name="witID" select="$witID"></xsl:with-param>
               </xsl:call-template>
            </xsl:if>
            <xsl:if test="//tei:note[@type='image']/tei:witDetail[@target = concat('#',$witID)]//tei:graphic[@url]">
               <xsl:call-template name="facs-images">
                  <xsl:with-param name="witID" select="$witID"></xsl:with-param>
               </xsl:call-template>
            </xsl:if>
            <xsl:apply-templates select="//tei:body" >
               <xsl:with-param name="witID" select="$witID" tunnel="yes"></xsl:with-param>
            </xsl:apply-templates>
            
         </div>
      </div>
      
   </xsl:template>
   
   <xsl:template name="audioPlayer">
      <xsl:param name="witID"></xsl:param>
      <!--foreach witness with media-->
      <xsl:value-of select="$witID"></xsl:value-of>
      <xsl:for-each select="//tei:witDetail[@target = concat('#',$witID) and tei:media[@url]]">
         
         <div>
            <xsl:attribute name="class">audioPlayer <xsl:value-of select="translate(@wit, '#', '')" /></xsl:attribute>
            <xsl:attribute name="data-witness"><xsl:value-of select="translate(@wit, '#', '')" /></xsl:attribute>
            <!--<audio controls="controls">-->
            <audio controls="controls" preload="none">
            <!--foreach source-->
            <xsl:for-each select="//tei:witDetail[@target = concat('#',$witID) and tei:media[@url]]/tei:media">
               
               <!--<source>-->
               <!--<xsl:attribute name="src"><xsl:value-of select="@url" /></xsl:attribute>
                           <xsl:attribute name="type"><xsl:value-of select="@mimeType" /></xsl:attribute>-->
               <!--  <span>
                  <xsl:attribute name="class">audioSource</xsl:attribute>
                  <xsl:attribute name="data-src"><xsl:value-of select="@url" /></xsl:attribute>
                  <xsl:attribute name="data-type"><xsl:value-of select="@mimeType" /></xsl:attribute>
                  -->
               <source>
                  <xsl:attribute name="class">audiosource</xsl:attribute>
                  <xsl:attribute name="src"><xsl:value-of select="@url" /></xsl:attribute>
                  <xsl:attribute name="type"><xsl:value-of select="@mimeType" /></xsl:attribute>
               </source>
                           
                  
                  
                  <!-- </span>-->
               <!--</source>-->
               
            </xsl:for-each><!--foreach source-->
               <xsl:text>Your browser does not support the audio element.</xsl:text>
            </audio>
            <!--</audio>-->
         </div>
         
      </xsl:for-each><!--foreach witness with media-->
      
   </xsl:template>
   
   <xsl:template name="facs-images">
      <xsl:param name="witID" />
         <!-- RB:make only a div if images exist -->
            <div class="facs-images">
               <xsl:for-each select="//tei:note[@type='image']/tei:witDetail[@target = concat('#',$witID)]//tei:graphic[@url]">
                  <xsl:call-template name="imageLink">
                     <xsl:with-param name="imageURL" select="@url" />
                     <xsl:with-param name="imgID" select="@xml:id"></xsl:with-param>
                     <xsl:with-param name="witness" select="translate(ancestor::tei:witDetail/@wit,'#','')" />
                  </xsl:call-template>
               </xsl:for-each>
            </div>
   </xsl:template>
   
   <xsl:template match="tei:body">
      <xsl:param name="witID" tunnel="yes" />
      <xsl:apply-templates>
         <xsl:with-param name="witID" select="$witID"></xsl:with-param>
      </xsl:apply-templates>
   </xsl:template>
   
   <xsl:template match="/tei:TEI/tei:teiHeader/tei:fileDesc">
      <div id="bibPanel">
         <xsl:attribute name="class">
            <xsl:text>ui-widget-content ui-resizable panel noDisplay</xsl:text>
         </xsl:attribute>
         
         
         <div class="panelBanner">
            <img class="closePanel" title="Close panel" src="{$closePanelButton}" alt="X (Close panel)" />
            Bibliographic Information
         </div>
         <div class="bibContent">
            <h2>
               <xsl:value-of select="$fullTitle" />
            </h2>
            <xsl:if test="tei:titleStmt/tei:author">
               <h3>
                  by <xsl:value-of select="tei:titleStmt/tei:author" />
               </h3>
            </xsl:if>
            <xsl:if test="tei:sourceDesc">
               <h4>Original Source</h4>
               <xsl:apply-templates select="tei:sourceDesc" />
            </xsl:if>
            <h4>Witness List</h4>
            <ul>
               <xsl:for-each select="$witnesses">
                  <li>
                     <strong>
                        <xsl:text>Witness </xsl:text>
                        <xsl:value-of select="@xml:id" />
                        <xsl:text>:</xsl:text>
                     </strong>
                     <xsl:text> </xsl:text>
                     <xsl:value-of select="." />
                  </li>
               </xsl:for-each>
            </ul>
            <xsl:if test="tei:notesStmt/tei:note[@anchored = 'true' and not(@type='image')]">
               <h4>Textual Notes</h4>
               <xsl:for-each select="tei:notesStmt/tei:note[@anchored = 'true' and not(@type='image')]">
                  <div class="note">
                     <xsl:if test="@type">
                        <em class="label">
                           <xsl:value-of select="@type" />
                           <xsl:text>:</xsl:text>
                        </em>
                        <xsl:text> </xsl:text>
                     </xsl:if>
                     <xsl:apply-templates />
                     <xsl:if test="position() != last()">
                        <hr />
                     </xsl:if>
                  </div>
               </xsl:for-each>
            </xsl:if>
            <h4>Electronic Edition Information:</h4>
            <xsl:if test="tei:titleStmt/tei:respStmt">
               <h5>Responsibility Statement:</h5>
               <ul>
                  <xsl:for-each select="tei:titleStmt/tei:respStmt">
                     <li>
                        <xsl:value-of select="concat(translate(substring(tei:resp,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),substring(tei:resp,2,string-length(tei:resp)))" />
                        <xsl:for-each select="tei:name | tei:persName | tei:orgName | tei:other">
                           <xsl:text> </xsl:text>
                           <xsl:value-of select="." />
                           <xsl:choose>
                              <xsl:when test="position() = last()"></xsl:when>
                              <xsl:when test="position() = last() - 1">
                                 <xsl:if test="last() &gt; 2">
                                    <xsl:text>,</xsl:text>
                                 </xsl:if>
                                 <xsl:text> and </xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>, </xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:for-each>
                     </li>
                  </xsl:for-each>
                  <xsl:if test="tei:titleStmt/tei:sponsor">
                     <li>
                        <xsl:text>Sponsored by </xsl:text>
                        <xsl:for-each select="tei:titleStmt/tei:sponsor/tei:orgName | tei:titleStmt/tei:sponsor/tei:persName | tei:titleStmt/tei:sponsor/tei:name | tei:titleStmt/tei:sponsor/tei:other">
                           <xsl:apply-templates select="." />
                           <xsl:choose>
                              <xsl:when test="position() = last()"></xsl:when>
                              <xsl:when test="position() = last() - 1">
                                 <xsl:if test="last() &gt; 2">
                                    <xsl:text>,</xsl:text>
                                 </xsl:if>
                                 <xsl:text> and </xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>, </xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:for-each>
                     </li>
                  </xsl:if>
                  <xsl:if test="tei:titleStmt/tei:funder">
                     <li>
                        <xsl:text>Funding provided by </xsl:text>
                        <xsl:for-each select="tei:titleStmt/tei:funder/tei:orgName | tei:titleStmt/tei:funder/tei:persName | tei:titleStmt/tei:funder/tei:name | tei:titleStmt/tei:funder/tei:other">
                           <xsl:apply-templates select="." />
                           <xsl:choose>
                              <xsl:when test="position() = last()"></xsl:when>
                              <xsl:when test="position() = last() - 1">
                                 <xsl:if test="last() &gt; 2">
                                    <xsl:text>,</xsl:text>
                                 </xsl:if>
                                 <xsl:text> and </xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>, </xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:for-each>
                     </li>
                  </xsl:if>
               </ul>
            </xsl:if>
            <xsl:apply-templates select="tei:publicationStmt" />
            <xsl:if test="tei:encodingDesc/tei:editorialDecl">
               <h4>Encoding Principles</h4>
               <xsl:apply-templates select="tei:encodingDesc/tei:editorialDecl" />
            </xsl:if>
            <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:encodingDesc" />
         
         </div>
      </div>
      <xsl:if test="//tei:notesStmt/tei:note[@type='critIntro']">
         <div id="critPanel">
            <xsl:attribute name="class">
               <xsl:text>ui-widget-content ui-resizable panel noDisplay</xsl:text>
            </xsl:attribute>
           
               <div class="panelBanner">
                  <img class="closePanel" title="Close panel" src="{$closePanelButton}" alt="X (Close panel)" />
                  Critical Introduction
               </div>
               <div class="critContent">
                  <xsl:if test="tei:notesStmt/tei:note[@type='critIntro']">
                     <h4>Critical Introduction</h4>
                     <xsl:for-each select="tei:notesStmt/tei:note[@type='critIntro']/tei:p | tei:notesStmt/tei:note[@type='critIntro']/tei:lg">
                        <xsl:apply-templates select="." />
                     </xsl:for-each>
                     
                  </xsl:if>
               </div>
            </div>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:publicationStmt">
      <h5>Publication Details:</h5>
      <xsl:apply-templates />
   </xsl:template>
   
   <xsl:template match="tei:publicationStmt/tei:publisher">
      <p>
         <xsl:text>Published by </xsl:text>
         <xsl:apply-templates />
         <xsl:text>.</xsl:text>
      </p>
   </xsl:template>
   
   <xsl:template match="tei:publicationStmt/tei:availability">
      <xsl:apply-templates />
   </xsl:template>
   
   <xsl:template match="/tei:TEI/tei:teiHeader/tei:encodingDesc">
      <h4>Encoding Principles</h4>
      <xsl:apply-templates />
   </xsl:template>
   
   <xsl:template match="/tei:TEI/tei:teiHeader/tei:encodingDesc/tei:editorialDecl">
      <xsl:apply-templates />
   </xsl:template>
   
   <xsl:template match="//tei:encodingDesc/tei:classDecl"></xsl:template>
   
   <xsl:template match="//tei:encodingDesc/tei:tagsDecl"></xsl:template>
   
   <xsl:template match="//tei:encodingDesc/tei:charDecl"></xsl:template>
   
   <xsl:template name="notesPanel">
      <div id="notesPanel">
         <xsl:attribute name="class">
            <xsl:text>ui-widget-content ui-resizable panel noDisplay</xsl:text>
         </xsl:attribute>
         
         <div class="panelBanner">
            <img class="closePanel" title="Close panel" src="{$closePanelButton}" alt="X (Close panel)" />
            Textual Notes
         </div>
         <xsl:for-each select="//tei:body//tei:note[not(@type='image')]">
            <xsl:if test="not(ancestor::tei:note)">
               <div>
                  <xsl:attribute name="class">
                     <xsl:text>noteContent</xsl:text>
                     <xsl:if test="ancestor::*/@wit">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="translate(ancestor::*/@wit,'#','')" />
                     </xsl:if>
                  </xsl:attribute>
                  <xsl:if test="ancestor::*/@wit">
                     <div class="witnesses">
                        <xsl:value-of select="translate(ancestor::*/@wit,'#','')" />
                     </div>
                  </xsl:if>
                  <xsl:choose>
                     <xsl:when test="ancestor::tei:l">
                        <div class="position">
                           <xsl:attribute name="onclick">
                              <xsl:text>matchLine('line</xsl:text>
                              <xsl:value-of select="generate-id(ancestor::tei:l)" />
                              <xsl:text>');</xsl:text>
                           </xsl:attribute>
                           <xsl:choose>
                              <xsl:when test="ancestor::tei:l[@n]">
                                 <xsl:text>Line number </xsl:text>
                                 <xsl:value-of select="ancestor::tei:l/@n" />
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>Unnumbered line</xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </div>
                     </xsl:when>
                     <xsl:when test="ancestor::tei:p and ancestor::tei:app">
                        <div class="position">
                           <xsl:attribute name="onclick">
                              <xsl:text>matchApp('app-</xsl:text>
                              <xsl:value-of select="generate-id(ancestor::tei:app)" />
                              <xsl:text>');</xsl:text>
                           </xsl:attribute>
                           Highlight prose section
                        </div>
                     </xsl:when>
                  </xsl:choose>
                  <strong>
                     <xsl:choose>
                        <xsl:when test="@type = 'critical'">
                           <xsl:text>Critical note:</xsl:text>
                        </xsl:when>
                        <xsl:when test="@type = 'biographical'">
                           <xsl:text>Biographical note:</xsl:text>
                        </xsl:when>
                        <xsl:when test="@type = 'physical'">
                           <xsl:text>Physical note:</xsl:text>
                        </xsl:when>
                        <xsl:when test="@type = 'gloss'">
                           <xsl:text>Gloss note:</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>Note:</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:text> </xsl:text>
                  </strong>
                  <xsl:apply-templates />
               </div>
            </xsl:if>
         </xsl:for-each>
         <div id="noNotesFound" class="noteContent">
            Sorry, but there are no notes associated with
            any currently displayed witness.
         </div>
      </div>
   </xsl:template>
   
   <xsl:template match="tei:head|tei:epigraph|tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6|tei:div7|tei:div8|tei:lg">
      <xsl:param name="witID" tunnel="yes"></xsl:param>
      <xsl:if test="descendant::*[contains(@wit, concat('#',$witID))]">
         <div>
            <xsl:attribute name="class">
               <xsl:value-of select="name(.)" />
               <xsl:if test="@n">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="name(.)" />
                  <xsl:text>-n</xsl:text>
                  <xsl:value-of select="@n" />
               </xsl:if>
               <xsl:if test="@type">
                  <xsl:text> type-</xsl:text>
                  <xsl:value-of select="@type" />
               </xsl:if>
               <xsl:if test="@rend">
                  <xsl:text> rend-</xsl:text>
                  <xsl:value-of select="@rend" />
               </xsl:if>
            </xsl:attribute>
            <xsl:attribute name="data-line-id">
               <xsl:value-of select="name(.)" /><xsl:value-of select="@n" />
               
            </xsl:attribute>
            <xsl:apply-templates>
               <xsl:with-param name="witID" select="$witID" tunnel="yes"></xsl:with-param>
            </xsl:apply-templates>
         </div>
      </xsl:if>
   </xsl:template>

   <xsl:template name="imageLink">
      <xsl:param name="imageURL" />
      <xsl:param name="witness" />
      <xsl:param name="imgID"/>
      <xsl:if test="$imageURL != ''">
         <img src="{$imageIcon}" alt="Facsimile Image Placeholder" title="Open the image viewer">
            <xsl:attribute name="class">
               <xsl:text>imageLink</xsl:text>
               <xsl:if test="$witness != ''">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$witness" />
               </xsl:if>
            </xsl:attribute>
            <xsl:attribute name="data-witness-id">
               <xsl:if test="$witness != ''">
                  <xsl:value-of select="$witness" />
               </xsl:if>
            </xsl:attribute>
            <xsl:attribute name="data-img-url">
               <xsl:value-of select="$imageURL" />
            </xsl:attribute>
            <xsl:attribute name="data-img-id">
               <xsl:value-of select="$imgID" />
            </xsl:attribute>
         </img>
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:fw" />
   
   
   
   <xsl:template match="tei:l[@n][descendant::tei:rdg]">
      <xsl:param name="witID" tunnel="yes" />
      
      <xsl:if test="descendant::tei:rdg[contains(@wit,$witID)]">
         <div>
            <xsl:attribute name="class">
               <xsl:text>line</xsl:text>
            </xsl:attribute>
            
            <div>
               <xsl:attribute name="class">
                  <xsl:text>linenumber noDisplay</xsl:text>
               </xsl:attribute>
               <xsl:value-of select="@n" />
            </div>
            <xsl:apply-templates>
               <xsl:with-param name="witID" tunnel="yes" select="$witID"></xsl:with-param>
            </xsl:apply-templates>
         </div>
         
      </xsl:if>
      
   </xsl:template>
   
   <xsl:template match="tei:l[not(@n)]">
      <xsl:param name="witID" tunnel="yes" />
      
      <xsl:if test="descendant::tei:rdg[contains(@wit,$witID)]">
      <div>
               <xsl:attribute name="class">
                  <xsl:text>line</xsl:text>
               </xsl:attribute>
               
               <xsl:choose>
                  <xsl:when test="tei:app">
                           <xsl:apply-templates>
                              <xsl:with-param name="witID" tunnel="yes" select="$witID"></xsl:with-param>
                           </xsl:apply-templates>
                  </xsl:when>
                  <xsl:when test="tei:rdg">
                     <xsl:apply-templates>
                        <xsl:with-param name="witID" tunnel="yes" select="$witID"></xsl:with-param>
                     </xsl:apply-templates>
                  </xsl:when>
                  <xsl:otherwise>
                     
                     <div>
                        <xsl:attribute name="data-witness">
                           <xsl:value-of select="translate(@wit,'#','')" />
                        </xsl:attribute>
                        <xsl:attribute name="class">
                           <xsl:text>reading </xsl:text>
                           <xsl:value-of select="translate(@wit,'#','')" />
                        </xsl:attribute>
                        <xsl:apply-templates />
                     </div>
                  </xsl:otherwise>
               </xsl:choose>
          </div>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:l[not(descendant::tei:rdg)]">
      <xsl:param name="witID" tunnel="yes" />

      <div>
            <xsl:attribute name="class">
               <xsl:text>line</xsl:text>
            </xsl:attribute>
            
            <div>
               <xsl:attribute name="class">
                  <xsl:text>linenumber noDisplay</xsl:text>
               </xsl:attribute>
               <xsl:value-of select="@n" />
            </div>
                  <div>
                     <xsl:attribute name="data-witness">
                        <xsl:value-of select="translate(@wit,'#','')" />
                     </xsl:attribute>
                     <xsl:attribute name="class">
                        <xsl:text>apparatus </xsl:text>
                        <xsl:text>app-all-</xsl:text><xsl:number></xsl:number>
                     </xsl:attribute>
                     <xsl:attribute name="data-app-id">
                        <xsl:text>app-all-</xsl:text><xsl:number></xsl:number>
                     </xsl:attribute>
                     <xsl:apply-templates />
                  </div>
              
         </div>
         
      
   </xsl:template>
   
   
   <xsl:template match="tei:hi">
      <span>
         <xsl:attribute name="class">
            <xsl:text>hi</xsl:text>
            <xsl:if test="@rend">
               <xsl:text> rend-</xsl:text>
               <xsl:value-of select="@rend" />
            </xsl:if>
         </xsl:attribute>
         <xsl:apply-templates />
      </span>
   </xsl:template>
   
   <xsl:template match="tei:del">
      <del>
         <xsl:if test="@rend">
            <xsl:attribute name="class">
               <xsl:text> rend-</xsl:text>
               <xsl:value-of select="@rend" />
            </xsl:attribute>
         </xsl:if>
         <xsl:apply-templates />
      </del>
   </xsl:template>
   
   <xsl:template match="tei:add">
      <ins>
         <xsl:if test="@rend or @place">
            <xsl:attribute name="class">
               <xsl:if test="@rend">
                  <xsl:text>rend-</xsl:text>
                  <xsl:value-of select="@rend" />
               </xsl:if>
               <xsl:if test="@rend and @place">
                  <xsl:text> </xsl:text>
               </xsl:if>
               <xsl:if test="@place">
                  <xsl:text>place-</xsl:text>
                  <xsl:value-of select="@place" />
               </xsl:if>
            </xsl:attribute>
         </xsl:if>
         <xsl:apply-templates />
      </ins>
   </xsl:template>
   
   <xsl:template match="tei:unclear">
      <span class="unclear">
         <xsl:apply-templates />
      </span>
   </xsl:template>
   
   <xsl:template match="tei:lb">
      <div class="linebreak"></div>
   </xsl:template>
   
   <xsl:template match="tei:pb">
      <xsl:param name="witID" tunnel="yes"></xsl:param>
      
      <xsl:if test="contains(@ed, $witID)">
         <hr>
            <xsl:attribute name="class">
               <xsl:text>pagebreak</xsl:text>
               <xsl:if test="@ed">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="translate(@ed,'#','')" />
               </xsl:if>
            </xsl:attribute>
         </hr>
         <xsl:if test="not(ancestor::tei:l) and @facs">
            <div class="facs-images">
            <xsl:call-template name="imageLink">
               <xsl:with-param name="imgID" select="substring-after(@facs,'#')"></xsl:with-param>
               <xsl:with-param name="imageURL">
                  <xsl:choose>
                     <xsl:when test="contains(@facs,'#')">
                        <xsl:variable name="facsID" select="translate(@facs,'#','')" />
                        <xsl:if test="//tei:facsimile//tei:graphic[@xml:id = $facsID]/@url">
                           <xsl:value-of select="//tei:facsimile//tei:graphic[@xml:id = $facsID]/@url" />
                        </xsl:if>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="@facs" />
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:with-param>
               <xsl:with-param name="witness">
                  <xsl:choose>
                     <xsl:when test="@ed">
                        <xsl:value-of select="translate(@ed,'#','')" />
                     </xsl:when>
                     <xsl:when test="ancestor::*/@wit">
                        <xsl:value-of select="translate(ancestor::*/@wit,'#','')" />
                     </xsl:when>
                  </xsl:choose>
               </xsl:with-param>
            </xsl:call-template>
            </div>
         </xsl:if>
      </xsl:if>
      
   </xsl:template>
   
   
   <xsl:template match="tei:p|tei:u">
      <!-- We cannot use the HTML <p>...</p> element here because of the
      different qualities of a TEI <p> and an HTML <p>. For example,
      TEI allows certain objects to be nested within a paragraph (like
      <table>...</table>) that HTML does not -->
      <xsl:choose>
         <xsl:when test="ancestor::tei:note or ancestor::tei:fileDesc or ancestor::tei:encodingDesc or tei:notesStmt">
            <p><xsl:apply-templates /></p>
         </xsl:when>
         <xsl:otherwise>
            <div class="paragraph">
               <xsl:apply-templates />
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!--DC-->
   <xsl:template match="tei:milestone[@unit = 'stanza']">
      <div>
         <xsl:attribute name="class">
            <xsl:text>stanzabreak</xsl:text>
            <xsl:if test="@ed">
               <xsl:text> </xsl:text>
               <xsl:value-of select="translate(@ed,'#','')" />
            </xsl:if>
         </xsl:attribute>
      </div>
   </xsl:template>
   
   <xsl:template match="tei:table">
      <table class="mssTable">
         <xsl:apply-templates />
      </table>
   </xsl:template>
   
   <xsl:template match="tei:table/tei:row">
      <tr>
         <xsl:apply-templates />
      </tr>
   </xsl:template>
   
   <xsl:template match="tei:table/tei:row/tei:cell">
      <td>
         <xsl:apply-templates />
      </td>
   </xsl:template>
   
   <xsl:template match="tei:rdgGrp">
      <xsl:choose>
         <xsl:when test="count(tei:rdg) &gt; 1">
            <div>
               <xsl:attribute name="class">
                  <xsl:text>rdgGrp</xsl:text>
<!--    MDH: @wit is not allowed on <rdgGrp>, so I'm commenting this out.         -->
                  <!--<xsl:if test="@wit">
                     <xsl:value-of select="concat(' ',translate(@wit,'#',''))" />
                  </xsl:if>-->
               </xsl:attribute>
               <xsl:value-of select="tei:rdg[position() = 1]" />
               <div class="altRdg">
                  <xsl:for-each select="tei:rdg[position() &gt; 1]">
                     <xsl:apply-templates />
                     <xsl:if test="position() != last()">
                        <hr />
                     </xsl:if>
                  </xsl:for-each>
               </div>
            </div>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="tei:space[@unit='char']">
      <xsl:variable name="quantity">
         <xsl:choose>
            <xsl:when test="@quantity">
               <xsl:value-of select="@quantity" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="1" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="whiteSpace">
         <xsl:with-param name="iteration" select="1" />
         <xsl:with-param name="quantity" select="$quantity" />
      </xsl:call-template>
   </xsl:template>
   
   <xsl:template name="whiteSpace">
      <xsl:param name="iteration" />
      <xsl:param name="quantity" />
      <xsl:text>&#xa0;</xsl:text>
      <xsl:if test="$iteration &lt; $quantity">
         <xsl:call-template name="whiteSpace">
            <xsl:with-param name="iteration" select="$iteration + 1" />
            <xsl:with-param name="quantity" select="$quantity" />
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="tei:note">
      <div class="noteicon">
         <xsl:choose>
            <xsl:when test="@type = 'critical'">
               <xsl:text>c</xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'biographical'">
               <xsl:text>b</xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'physical'">
               <xsl:text>p</xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'gloss'">
               <xsl:text>g</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>n</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
         <div class="note">
            <strong>
               <xsl:choose>
                  <xsl:when test="@type = 'critical'">
                     <xsl:text>Critical note:</xsl:text>
                  </xsl:when>
                  <xsl:when test="@type = 'biographical'">
                     <xsl:text>Biographical note:</xsl:text>
                  </xsl:when>
                  <xsl:when test="@type = 'physical'">
                     <xsl:text>Physical note:</xsl:text>
                  </xsl:when>
                  <xsl:when test="@type = 'gloss'">
                     <xsl:text>Gloss note:</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>Note:</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </strong>
            <xsl:text> </xsl:text>
            <xsl:apply-templates />
         </div>
      </div>
   </xsl:template>
   
   <xsl:template match="tei:note//tei:note">
      <br />
      <xsl:apply-templates />
   </xsl:template>
   
   <xsl:template match="tei:figure"></xsl:template>
   
  
   <xsl:template match="tei:app">
      <xsl:param name="witID" tunnel="yes"></xsl:param>
      
      <xsl:variable name="uniqueID">
         <xsl:choose>
            <xsl:when test="@loc"><xsl:value-of select="@loc"/></xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="name(.)"></xsl:value-of>
               <xsl:text>_</xsl:text>
               <xsl:value-of select="position()"></xsl:value-of>
               <xsl:text>_</xsl:text>
               <xsl:value-of select="name(parent::node())"></xsl:value-of>
               <xsl:if test="parent::node()[@n]">
                   <xsl:text>_</xsl:text><xsl:value-of select="parent::node()/@n"></xsl:value-of><xsl:text>_</xsl:text>
               </xsl:if>
               <xsl:value-of select="parent::node()/position()"></xsl:value-of>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="refID">#<xsl:value-of select="$witID"/></xsl:variable>
      
      <xsl:for-each select="tei:rdg">
         <xsl:variable name="wit" select="@wit"></xsl:variable>
         <xsl:if test="contains($wit, $witID) or contains($wit, 'all')">
            <div>
               <xsl:if test="tei:rdg[contains(@wit, $refID)]/tei:timeline/tei:when">
                  <xsl:for-each select="tei:rdg[contains(@wit, $refID)]/tei:timeline/tei:when">
      
                     <xsl:if test="@since">
                        <xsl:attribute name="data-timeline">
                           <xsl:value-of select="translate(@since,'#','')" />
                        </xsl:attribute> 
                     </xsl:if>  
                  </xsl:for-each>
               </xsl:if>
               <xsl:attribute name="class">
                  <xsl:text>apparatus </xsl:text>
                  <xsl:value-of select="$uniqueID"></xsl:value-of>
                  <xsl:if test="@loc">
                     <xsl:text> app-</xsl:text>
                     <xsl:value-of select="@loc" />
                  </xsl:if>
               </xsl:attribute>
               <!-- ID for apparatus: important for highlighting of text lines and location based referencing -->
               <xsl:attribute name="data-app-id">
                  <xsl:value-of select="$uniqueID"></xsl:value-of>
               </xsl:attribute>
               <xsl:if test="tei:timeline[@unit='s']">
                  <xsl:attribute name="data-timeline-start">
                     <!--  sum(/*/Dev/Salary[number(.) = number(.)])-->
                     
                     <xsl:value-of select="sum(preceding::tei:rdg[contains(@wit, $refID)]/tei:timeline/tei:when/@interval)" />
                  </xsl:attribute>
                  
                  <xsl:attribute name="data-timeline-interval">
                     <xsl:value-of select="tei:timeline/tei:when/@interval" />
                  </xsl:attribute>
               </xsl:if>
               
               
                     <xsl:choose>
                        <xsl:when test="not(ancestor::tei:rdgGrp)">
                           <div>
                              <xsl:attribute name="data-witness">
                                 <xsl:value-of select="translate(@wit,'#','')" />
                              </xsl:attribute>
                              <xsl:attribute name="class">
                                 <xsl:text>reading </xsl:text>
                                 <xsl:value-of select="translate(@wit,'#','')" />
                              </xsl:attribute>
                              <xsl:apply-templates>
                                 <xsl:with-param name="witID" tunnel="yes" select="$witID"></xsl:with-param>
                              </xsl:apply-templates>
                           </div>
                        </xsl:when>
                        <xsl:otherwise>
                           <div>
                              <xsl:attribute name="class">rdg</xsl:attribute>
                              <xsl:attribute name="data-line-id"><xsl:value-of select="@wit"/></xsl:attribute>
                              <xsl:apply-templates>
                                 <xsl:with-param name="witID" tunnel="yes" select="$witID"></xsl:with-param>
                              </xsl:apply-templates>
                           </div>
                        </xsl:otherwise>
                     </xsl:choose>
               
            </div>
         </xsl:if>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="tei:rdg|tei:lem">
      <xsl:param name="witID" tunnel="yes"></xsl:param>
      <xsl:if test="contains(@wit, concat('#',$witID))">
         <xsl:apply-templates>
            <xsl:with-param name="witID" tunnel="yes" select="$witID"></xsl:with-param>
         </xsl:apply-templates>
      </xsl:if>
      
   </xsl:template>
 
   <xsl:template match="tei:choice">
      <xsl:choose>
         <xsl:when test="tei:sic and tei:corr">
            <xsl:call-template name="displayChoice">
               <xsl:with-param name="inline" select="tei:sic" />
               <xsl:with-param name="hover" select="tei:corr" />
               <xsl:with-param name="label" select="'Correction:'" />
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="tei:orig and tei:reg">            
            <xsl:call-template name="displayChoice">
               <xsl:with-param name="inline" select="tei:orig" />
               <xsl:with-param name="hover" select="tei:reg" />
               <xsl:with-param name="label" select="'Regularized form:'" />
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="tei:abbr and tei:expan">
            <xsl:call-template name="displayChoice">
               <xsl:with-param name="inline" select="tei:abbr" />
               <xsl:with-param name="hover" select="tei:expan" />
               <xsl:with-param name="label" select="'Expanded abbreviation:'" />
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="count(*) &gt;= 2">
            <xsl:call-template name="displayChoice">
               <xsl:with-param name="inline" select="*[1]" />
               <xsl:with-param name="hover" select="*[2]" />
               <xsl:with-param name="label" select="''" />
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template name="displayChoice">
      <xsl:param name="inline" />
      <xsl:param name="hover" />
      <xsl:param name="label" />
      <div class="choice">
         <xsl:apply-templates select="$inline" />
         <div class="corr">
            <div class="interior">
               <xsl:if test="$label != ''">
                  <strong><xsl:value-of select="$label" /></strong>
                  <xsl:text> </xsl:text>
               </xsl:if>
               <xsl:apply-templates select="$hover" />
            </div>
         </div>
      </div>
   </xsl:template>
   
   <xsl:template name="imageViewer">
      <xsl:param name="imgId"></xsl:param>
      <xsl:param name="imgUrl"></xsl:param>
      <div class="draggable resizable ui-resizable panel imgPanel noDisplay" id="{$imgId}">
         <div title="Click to drag panel." class="viewerHandle handle_imageViewer">
            <span class="viewerHandleLt title_imageViewer">
               <xsl:value-of select="$imgUrl"></xsl:value-of>
            </span>
            <img class="viewerHandleRt closePanel" src="{$closePanelButton}" title="Close panel" alt="X (Close panel)" />
         </div>
         <div class="viewerContent" id="content_imageViewer">
             
            <!-- RB: jquery.panzoom plugin from https://github.com/timmywil/jquery.panzoom The links to the JS and CSS files are in the facsimile template-->
            
               <div class="panzoom-parent" style="overflow:visible">
            <!-- panzoom image -->
            <div class="panzoom">
                     <img width="200" border="1px 2px, 2px, 1px solid #000;" alt="image">
                        <xsl:attribute name="src">
                           <xsl:value-of select="$facsImageFolder"/>
                           <xsl:value-of select="$imgUrl" />
                        </xsl:attribute>
                        
                     </img>
                  </div>
                 
               </div><!-- zoom parent end -->
            <!-- zoom control -->
            <div class="buttons">
               <button class="zoom-out">-</button>
               <input type="range" min="0" max="100" class="zoom-range"/>
               <button class="zoom-in">+</button>
               
            </div>
            
            
            
            <!-- End implementation of jquery.panzoom -->
         </div>
         
      </div>
   </xsl:template>
   
   <xsl:template name="truncateText">
      <xsl:param name="string"/>
      <xsl:param name="length"/>
      <xsl:choose>
         <xsl:when test="string-length($string) &gt; $length">
            <xsl:value-of select="concat(substring($string,1,$length),'...')" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$string" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="tei:ref">
      <a class="link">
         <xsl:attribute name="href">
            <xsl:value-of select="@target"/>
         </xsl:attribute>
         <xsl:value-of select="." />
        
         
      </a>
      
   </xsl:template>
  <xsl:template match="tei:closer">
      <div class="closer">
     
         <xsl:apply-templates/>
         
      </div>
      
   </xsl:template>
   
   
   <xsl:template match="tei:head[(@type='section')]">
      <div class="section">
         
         <xsl:apply-templates/>
         
      </div>
      
   </xsl:template>


   <xsl:template name="createTimelinePoints">   
        
        <xsl:text>var timelinePoints = new Array();</xsl:text>
        
        <xsl:for-each select="//tei:when">
            <xsl:choose>
<!--              MDH: Change to the way we deal with @absolute: it may not be there. -->
              <!--<xsl:when test="@absolute">
                <xsl:text>&#x0a;timelinePoints['</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>']=</xsl:text><xsl:value-of select="@absolute"/><xsl:text>;</xsl:text>
              </xsl:when>-->
                <xsl:when test="not(@since)">
                  <xsl:text>&#x0a;timelinePoints['</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>']=</xsl:text><xsl:choose><xsl:when test="@absolute"><xsl:value-of select="@absolute"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose><xsl:text>;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#x0a;timelinePoints['</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>']=</xsl:text><xsl:call-template name="calculateTimeOffset"><xsl:with-param name="when" select="."/><xsl:with-param name="offsetSoFar" select="0"/></xsl:call-template><xsl:text>;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="calculateTimeOffset">
        <xsl:param name="when"/>
        <xsl:param name="offsetSoFar"/>
        <xsl:choose>
            <xsl:when test="$when/@since">
                <xsl:variable name="prevId" select="substring-after($when/@since, '#')"/>
                <xsl:call-template name="calculateTimeOffset">
                    <xsl:with-param name="when" select="//tei:when[@xml:id=$prevId]"/>
                    <xsl:with-param name="offsetSoFar" select="$offsetSoFar + $when/@interval"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$offsetSoFar"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

   <xsl:template name="createTimelineDurations">   

        <xsl:text>var timelineDurations = new Array();</xsl:text>    
      
         <xsl:for-each select="//tei:when">
            <xsl:choose>
<!--              MDH: Change to the way we deal with @absolute: it may not be there. -->
                <!--<xsl:when test="@absolute">
                    <xsl:text>&#x0a;timelineDurations['</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>']=0;</xsl:text>
                </xsl:when>-->
              <xsl:when test="not(@since)">
                <xsl:text>&#x0a;timelineDurations['</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>']=0;</xsl:text>
              </xsl:when>
                <xsl:otherwise>
                     <xsl:text>&#x0a;timelineDurations['</xsl:text><xsl:value-of select="translate(@since,'#','')" /><xsl:text>']=</xsl:text><xsl:value-of select="@interval"/><xsl:text>;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
    </xsl:template>
   
</xsl:stylesheet>