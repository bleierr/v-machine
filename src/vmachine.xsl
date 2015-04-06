<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="tei"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns="http://www.w3.org/1999/xhtml">
   
   <!--Old doctype declaration-->
   <!--<xsl:output method="html" version="4.01" encoding="utf-8" indent="yes" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN" />-->

   <!-- New doctype declarationfrom http://stackoverflow.com/questions/6334381/how-to-output-doctype-html-with-xslt-->
   <xsl:output method="html" doctype-system="about:legacy-compat" />

   <!-- <xsl:strip-space elements="*" /> -->
   
   <xsl:variable name="indexPage">../samples.html</xsl:variable>
   
   <xsl:variable name="vmLogo">../vm-images/poweredby.gif</xsl:variable>
   
   <xsl:variable name="cssInclude">../src/vmachine.css</xsl:variable>
   
   <xsl:variable name="cssJQuery-UI">../src/js/jquery-ui-1.11.3/jquery-ui.min.css</xsl:variable>
   
   
     <!-- The JavaScript include file. Keep in mind that, as of April 1, 2008,
   the current beta version of Firefox 3.0 has instituted strong JavaScript
   security policies that prevent the inclusion of any JS files from outside
   of the current directory when loading a document from the local filesystem
   (i.e., anything on your local computer not beginning with "http://").
   Because of this, if you want to use the VM offline, you will need to
   move the JavaScript includes into the same directory as your TEI documents,
   and modify the filename below (for example, "../src/vmachine.js" becomes
   "vmachine.js") -->
   <xsl:variable name="jsInclude">../src/vmachine.js</xsl:variable>
   
   <!-- JQuery include files -->
   <xsl:variable name="jsJquery">../src/js/jquery-1.11.2.min.js</xsl:variable>
   <xsl:variable name="jsJquery-UI">../src/js/jquery-ui-1.11.3/jquery-ui.min.js</xsl:variable>


   <xsl:variable name="initialVersions">1</xsl:variable>
   
   <!-- To change the VM so that the bibliographic information page does not
   appear at the initial load, change "true" to "false" below -->
   <xsl:variable name="displayBibInfo">true</xsl:variable>
   <xsl:variable name="displayCritInfo">true</xsl:variable>
   
  <!-- To change the VM so that line numbers are hidden by default, change
  "true" to "false" below -->
   <xsl:variable name="displayLineNumbers">true</xsl:variable>
   
   <!-- To change the VM's default method of displaying notes, modify the
   following variable:
      - popup: Popup footnote icons
      - inline: Inline note viewer panel
      - none: Hide notes
   -->
   <xsl:variable name="notesFormat">popup</xsl:variable>
   
   
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
        <body> <!--  onload="init();" -->
            <xsl:call-template name="mainBanner" />
            <xsl:call-template name="manuscriptArea" />
            <xsl:for-each select="//tei:facsimile/tei:graphic">
               <xsl:call-template name="imageViewer" >
                  <xsl:with-param name="imgUrl" select="@url"></xsl:with-param>
                  <xsl:with-param name="imgId" select="@xml:id"></xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <!--<xsl:call-template name="imageViewer" />-->
            <!-- <p>There are <xsl:value-of select="count($witnesses)" /> witnesses.</p> -->
         </body>
      </html>
   </xsl:template>
   
   <xsl:template name="htmlHead">
      <head>
         <title>
            <xsl:value-of select="$truncatedTitle" />
            <xsl:text> -- The Versioning Machine 4.0</xsl:text>
         </title>
         <meta charset="utf-8"/>
         <link rel="stylesheet" type="text/css">
            <xsl:attribute name="href">
               <xsl:value-of select="$cssInclude" />
            </xsl:attribute>
         </link>
         <xsl:comment><![CDATA[[if IE 6]>
            <link rel="stylesheet" type="text/css" href="../src/vmachine_ie6.css">
         <![endif]]]></xsl:comment>
         
         <!-- RB: added JQuery and JQuery UI support -->
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
         <script type="text/javascript">
            <xsl:attribute name="src">
               <xsl:value-of select="$jsInclude" />
            </xsl:attribute>
         </script>
         <script type="text/javascript">
            <xsl:call-template name="jsWitnessArray" />
            <xsl:call-template name="createTimelinePoints" />
            <xsl:call-template name="createTimelineDurations" />
         </script>
         <!-- RB: JS and CSS files for the zoom and pan effect -->
         <!-- RB: jquery.panzoom plugin from https://github.com/timmywil/jquery.panzoom -->
         <link rel="stylesheet" type="text/css" href="../src/panzoom/panzoom.css"></link>
         <script src="../src/panzoom/jquery.panzoom.min.js" type="text/javascript">//</script>
         
         
         
      </head>
   </xsl:template>
   
   <xsl:template name="jsWitnessArray">
      var witnesses = new Array();
      <xsl:for-each select="$witnesses">
         <xsl:variable name="witID" select="@xml:id" />
         witnesses["<xsl:value-of select="$witID" />"] = "<xsl:for-each select="ancestor::tei:listWit[@xml:id]">
            <xsl:value-of select="@xml:id" />
            <xsl:text>;</xsl:text>
         </xsl:for-each>
         <xsl:value-of select="$witID" />";
      </xsl:for-each>
      var maxPanels = <xsl:value-of select="$numWitnesses" />;
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
         <!-- <h1 onclick="toggleBiblio();">
            <xsl:value-of select="$truncatedTitle" />
         </h1> -->
         <h1>
            <xsl:value-of select="$truncatedTitle" />
         </h1>
         <!-- <span class="versionCount">
            <xsl:text> has </xsl:text>
            <xsl:value-of select="$numWitnesses" />
            <xsl:text> version</xsl:text>
            <xsl:if test="$numWitnesses &gt; 1">
               <xsl:text>s</xsl:text>
            </xsl:if>
         </span> -->
      </div>
   </xsl:template>
   
   <xsl:template name="mainControls">
      <nav id="mainControls">
         
         <ul>
            <!--  
            <li>
               <button id="info" type="button" onclick="#" >INFO</button>
            </li>
            <input type="button" id="newPanel" value="New Version" onclick="openPanel();" />
         &#8226;-->
            <!--  
         <input type="button" id="bibToggle" value="Bibliographic Info" onclick="toggleBiblio();" />
         -->
                
            <li>
               <span>
                  <xsl:attribute name="id">selectWitness</xsl:attribute>
                  <xsl:attribute name="class">dropdownButton</xsl:attribute>
                  <xsl:value-of select="count($witnesses)"></xsl:value-of>
                  <xsl:text> Total Witnesses</xsl:text>
                  
               </span>
               <!-- RB: version dropdown -->
               <xsl:call-template name="versionDropdown"/>
            </li>
            <li>
               <span>
                  <xsl:attribute name="id">controlDropdown</xsl:attribute>
                  <xsl:attribute name="class">dropdownButton</xsl:attribute>
                  <xsl:text>Control dropdown</xsl:text>
                  
               </span>
               <!-- RB: control dropdown -->
               <xsl:call-template name="controlDropdown"/>
            </li>  
            
            
            
            <!--
            <li>
               <input type="button" id="critToggle" value="Critical Introduction" onclick="toggleCrit();" >-->
                  <!--This isn't working when $displayCritInfo is true but there's no relevant note. Copied the if statement from Martin below. -->
                  <!-- <xsl:if test="$displayCritInfo != 'true' or not(tei:notesStmt/tei:note[@type='critIntro'])">
                     <xsl:attribute name="style">
                        <xsl:text>display: none;</xsl:text>
                     </xsl:attribute>
                  </xsl:if>            
               </input>
            </li>
            <li>  -->
               <!-- &#8226;
               <input type="button" id="helpToggle" value="Help Viewer" onclick="toggleHelp();" /> -->
               <!-- 
               <label for="toggleLineNumbers">Line Numbers:</label>
               <button>
                  <xsl:attribute name="id">displayLines</xsl:attribute>
                  <xsl:text>ON</xsl:text>
               </button> -->
               <!-- <input type="checkbox" id="toggleLineNumbers" onclick="toggleLineNumbers(this.checked);">
                  <xsl:if test="$displayLineNumbers != 'false'">
                     <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
               </input> -->
              
            <!--</li>
            <li>
               <select id="notesMenu">
                  <xsl:choose>
                     <xsl:when test="//tei:body//tei:note[not(@type='image')]">
                        <xsl:attribute name="onchange">
                           <xsl:text>notesFormat(this.value);</xsl:text>
                        </xsl:attribute>
                        <option value="popup">
                           <xsl:if test="$notesFormat = 'popup'">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                           </xsl:if>
                           <xsl:text>Popup notes</xsl:text>
                        </option>
                        <option value="inline">
                           <xsl:if test="$notesFormat = 'inline'">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                           </xsl:if>
                           <xsl:text>Inline notes</xsl:text>
                        </option>
                        <option value="none">
                           <xsl:if test="$notesFormat = 'none'">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                           </xsl:if>
                           Hide notes
                        </option>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:attribute name="disabled">
                           disabled
                        </xsl:attribute>
                        <option>No notes found</option>
                     </xsl:otherwise>
                  </xsl:choose>
               </select> -->
               <!-- &#8226;
               <a>
                  <xsl:attribute name="href">
                     <xsl:value-of select="$indexPage" />
                  </xsl:attribute>
                  <xsl:text>Index of texts</xsl:text>
               </a> 
            </li>-->
         </ul>
         
         
      </nav>
      
   </xsl:template>
   
   <xsl:template name="versionDropdown">
     
      <ul>
         <xsl:attribute name="id">witnessList</xsl:attribute>
         <xsl:attribute name="class">dropdown</xsl:attribute>
            <xsl:for-each select="$witnesses">
                 <li>
                    <xsl:attribute name="data-panelid">
                           <xsl:value-of select="@xml:id"></xsl:value-of>
                        </xsl:attribute>
                   <div>
                      <xsl:attribute name="class">listText</xsl:attribute>
                      
                   <p>
                         <xsl:value-of select="."></xsl:value-of>
                   </p> 
                   
                    <div class="image-container">
                      <img class="invisible" src="../vm-images/symbol-visible.png" alt=""/>
                      <img src="../vm-images/symbol-not-visible.png" alt=""/>
                    </div>
                   </div>
                </li>
           </xsl:for-each>
       </ul>
            
      
      
   </xsl:template>
   
   
   <xsl:template name="controlDropdown">
      <ul>
         <xsl:attribute name="id">controlList</xsl:attribute>
         <xsl:attribute name="class">dropdown</xsl:attribute>
          
         <li data-panelid="bibPanel">
            <div>
               <xsl:attribute name="class">listText</xsl:attribute>
               
               <p>
                  <xsl:text>Bibliographic panel</xsl:text>
               </p> 
               
               <div class="image-container">
                  <img class="invisible" src="../vm-images/symbol-visible.png" alt=""/>
                  <img src="../vm-images/symbol-not-visible.png" alt=""/>
               </div>
            </div>
            </li>
         <li data-panelid="lineNumbers"> <!--  onclick="toggleLineNumbers(false);" -->
            <div>
               <xsl:attribute name="class">listText</xsl:attribute>
               <p>
                  <xsl:text>Line numbers</xsl:text>
               </p> 
               
               <div class="image-container">
                  <img class="invisible" src="../vm-images/symbol-visible.png" alt=""/>
                  <img src="../vm-images/symbol-not-visible.png" alt=""/>
               </div>
            </div>
         </li>
         <li data-panelid="notesPanel"> <!-- onclick="notesFormat('popup');" -->
            <div>
               <xsl:attribute name="class">listText</xsl:attribute>
               <p>
                  <xsl:text>Notes Panel</xsl:text>
               </p> 
               
               <div class="image-container">
                  <img class="invisible" src="../vm-images/symbol-visible.png" alt=""/>
                  <img src="../vm-images/symbol-not-visible.png" alt=""/>
               </div>
            </div>
         </li>
         <li data-panelid="critPanel">
            <div>
               <xsl:attribute name="class">listText</xsl:attribute>
               
               <p>
                  <xsl:text>Critical notes</xsl:text>
               </p> 
               
               <div class="image-container">
                  <img class="invisible" src="../vm-images/symbol-visible.png" alt=""/>
                  <img src="../vm-images/symbol-not-visible.png" alt=""/>
               </div>
            </div>
         </li>
      </ul>
   </xsl:template>
   
   
   
   
   
   <xsl:template name="manuscriptArea">
      <div id="mssArea">
         <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc" />
         <div id="manuscripts">
            <xsl:for-each select="$witnesses">
               <xsl:call-template name="manuscriptPanel">
                  <xsl:with-param name="increment" select="'1'" />
                  <xsl:with-param name="witID" select="@xml:id" />
               </xsl:call-template>
            </xsl:for-each>
         </div>
         <xsl:call-template name="notesPanel" />
         <br class="clear" />
         <!--  <div id="contentData" style="display:none;">
         <xsl:call-template name="contentData"></xsl:call-template>
         </div>-->
      </div>
   </xsl:template>
   
   <xsl:template name="manuscriptPanel">
      <xsl:param name="increment" />
      <xsl:param name="witID" />
      <!-- RB: added draggable resizeable -->
      <div>
         <xsl:attribute name="class">
            <xsl:text>panel mssPanel draggable resizable ui-widget-content ui-resizable</xsl:text>
         </xsl:attribute>
         <xsl:attribute name="id">
            <xsl:value-of select="$witID"></xsl:value-of>
         </xsl:attribute>
         <div class="panelBanner">
            <!-- <img class="closePanel" onclick="closePanel(this.parentNode.parentNode);" src="../vm-images/closePanel.gif" alt="X (Close panel)" /> -->
            <img class="closePanel" src="../vm-images/closePanel.gif" alt="X (Close panel)" />
            <xsl:text>Witness </xsl:text><xsl:value-of select="$witID"></xsl:value-of>
            <!-- <select class="witnessMenu" onchange="changeWitness(this.value,this.parentNode.parentNode);">
               <xsl:for-each select="//tei:witness">
                  <option>
                     <xsl:if test="position() = number($increment)">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                     </xsl:if>
                     <xsl:attribute name="value">
                        <xsl:value-of select="@xml:id" />
                     </xsl:attribute>
                     <xsl:value-of select="position()" />
                     <xsl:text>: </xsl:text>
                     <xsl:value-of select="@xml:id" />
                  </option>
               </xsl:for-each>
            </select>
            -->
            <!-- RB added static banner name -->
            
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
      <xsl:if test="$increment &lt; $initialVersions">
         <xsl:call-template name="manuscriptPanel">
            <xsl:with-param name="increment" select="$increment + 1" />
         </xsl:call-template>
      </xsl:if>
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
            <audio controls="controls">
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
      <div class="panel" id="bibPanel">
         <xsl:if test="$displayBibInfo != 'true'">
            <xsl:attribute name="style">
               <xsl:text>display: none;</xsl:text>
            </xsl:attribute>
         </xsl:if>
         <div class="panelBanner">
            <img class="closePanel" alt="X (Close panel)" src="../vm-images/closePanel.gif" />
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
      <div class="panel" id="critPanel">
        <xsl:if test="$displayCritInfo != 'true' or not(tei:notesStmt/tei:note[@type='critIntro'])">
               <xsl:attribute name="style">
                  <xsl:text>display: none;</xsl:text>
               </xsl:attribute>
            </xsl:if>
        
            <div class="panelBanner">
               <img class="closePanel" alt="X (Close panel)" src="../vm-images/closePanel.gif" />
               Critical Introduction
            </div>
            <div class="critContent">
               <xsl:if test="tei:notesStmt/tei:note[@type='critIntro']">
                  <h4>Critical Introduction</h4>
                  <xsl:for-each select="tei:notesStmt/tei:note[@type='critIntro']/tei:p | tei:notesStmt/tei:note[@type='critIntro']/tei:lg">
                     <xsl:apply-templates select="." />
                </xsl:for-each>
                  
                  
                  
                  
              <!--    
                  <xsl:for-each select="tei:notesStmt/tei:note[@type='critIntro']/tei:p">
                     <p>        <xsl:apply-templates /></p>
                  </xsl:for-each>
                -->
               </xsl:if>
            </div>
         </div>
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
      <div class="panel" id="notesPanel">
         <xsl:if test="$notesFormat != 'inline'">
            <xsl:attribute name="style">
               <xsl:text>display: none;</xsl:text>
            </xsl:attribute>
         </xsl:if>
         <div class="panelBanner">
            <img class="closePanel" alt="X (Close panel)" src="../vm-images/closePanel.gif" />
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
         <img src="../vm-images/image.gif" alt="Facsimile Image Placeholder">
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
            <!-- <xsl:attribute name="onclick">
               <xsl:text>return showImgPanel(event, 'imageViewer','</xsl:text>
               <xsl:value-of select="$imageURL" />
               <xsl:text>','</xsl:text>
               <xsl:value-of select="$witness" />
               <xsl:text>','-250','0');</xsl:text>
            </xsl:attribute> -->
         </img>
      </xsl:if>
   </xsl:template>
   
  <!--  <xsl:template name="imageLink">
      <xsl:param name="imageURL" />
      <xsl:param name="witness" />
      <xsl:param name="witID" />
      <xsl:variable name="pos">
         <xsl:number value="position()" format="1" />
      </xsl:variable>
      <xsl:if test="$imageURL != ''">
         <div class="illgrp" id="item-image">
            <xsl:attribute name="class">
               <xsl:text>imageLink</xsl:text>
               <xsl:if test="$witness != ''">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$witness" />
               </xsl:if>
            </xsl:attribute>--> 
            <!-- RB: jquery.panzoom plugin from https://github.com/timmywil/jquery.panzoom The links to the JS and CSS files are in the facsimile template-->
            
            <!--<xsl:variable name="img-container-id">panzoom<xsl:value-of select="$pos"/></xsl:variable>
            <xsl:element name="div">
               <xsl:attribute name="class">section</xsl:attribute>
               <xsl:attribute name="id"><xsl:value-of select="$img-container-id"/></xsl:attribute>
               
               
               <div class="panzoom-parent">--> 
                  <!-- zoom control -->
                  <!--<div class="buttons">
                     <button class="zoom-in">+</button>
                     <button class="zoom-out">-</button>
                     <input type="range" class="zoom-range"/>
                     <button class="reset">Reset</button>
                  </div>--> 
                  <!-- panzoom image -->
                  <!--<div class="panzoom">
                     <img width="200" border="1px 2px, 2px, 1px solid #000;" alt="image">
                        <xsl:attribute name="src">
                           <xsl:value-of select="$imageURL" />
                        </xsl:attribute>
                        
                     </img>
                  </div>
               </div>
               
               <script  type="text/javascript">
                  (function() {
                  var $section = $(<xsl:text>'div#</xsl:text><xsl:value-of select="$img-container-id"/><xsl:text>'</xsl:text>);
                  $section.find('.panzoom').panzoom({
                  $zoomIn: $section.find(".zoom-in"),
                  $zoomOut: $section.find(".zoom-out"),
                  $zoomRange: $section.find(".zoom-range"),
                  $reset: $section.find(".reset")
                  });
                  })();
               </script>
               
            </xsl:element>--> 
            <!-- End implementation of jquery.panzoom -->
         <!--</div>
         
      </xsl:if>
   </xsl:template>--> 
   
   
   
   
   <xsl:template match="tei:fw" />
   
   <xsl:template match="tei:l">
      <xsl:param name="witID" tunnel="yes" />
      <xsl:variable name="uniqueID">
         <xsl:choose>
            <xsl:when test="@n"><xsl:value-of select="@n"/></xsl:when>
            <xsl:otherwise><xsl:number></xsl:number></xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- ??? rdg display problem RB not solved yet 
      <xsl:choose>
         <xsl:when test="descendant::tei:lem[contains(@wit, concat('#',$witID))]
            or descendant::tei:rdg[contains(@wit, concat('#',$witID))]">
            -->
      <xsl:if test="not(descendant::tei:rdg) or descendant::tei:lem[contains(@wit, concat('#',$witID))]
         or descendant::tei:rdg[contains(@wit, concat('#',$witID))]">
            <div>
               <xsl:attribute name="class">
                  <xsl:text>line</xsl:text>
                  <xsl:text> line</xsl:text>
                  <xsl:value-of select="$uniqueID" />
               </xsl:attribute>
               
               <xsl:attribute name="line-id">
                  <xsl:text>line</xsl:text>
                  <xsl:value-of select="$uniqueID" />
               </xsl:attribute>
               
               <!--DC-->
               <!-- <xsl:if test="not(@loc) and not(descendant::*/@loc)">
                 <xsl:attribute name="onclick">
                     <xsl:text>matchLine('line</xsl:text>
                     <xsl:value-of select="$uniqueID" />
                     <xsl:text>');</xsl:text>
                  </xsl:attribute>
                  </xsl:if> -->
               <!--/DC-->
               
               <div>
                  <xsl:choose>
                     <xsl:when test="@n">
                        <xsl:attribute name="class">
                           <xsl:text>linenumber</xsl:text>
                        </xsl:attribute>
                        <xsl:if test="$displayLineNumbers = 'false'">
                           <xsl:attribute name="style">
                              <xsl:text>visibility: hidden;</xsl:text>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="@n" />
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:attribute name="class">
                           <xsl:text>emptynumber</xsl:text>
                        </xsl:attribute>
                        <xsl:text>&#160;</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </div>
               
               <xsl:apply-templates>
                  <xsl:with-param name="witID" tunnel="yes" select="$witID"></xsl:with-param>
               </xsl:apply-templates>
            </div>
      </xsl:if>
            <!--<xsl:for-each select=".//*[@facs]">
            <xsl:call-template name="imageLink">
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
         </xsl:for-each>-->
            
            
           <!--  
         </xsl:when>
         <xsl:when test="descendant::tei:rdg">ZZZZ</xsl:when>
      </xsl:choose>--> 
      
   </xsl:template>
   
   
   <!--  there is a rule for rdg further below about Line 1206
   <xsl:template match="tei:rdg">
      <div>
         <xsl:attribute name="class">
            line
         </xsl:attribute>
         <xsl:apply-templates />
      </div>
   </xsl:template>
   -->
      
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
      <br>
         <xsl:attribute name="class">
            <xsl:text>stanzabreak</xsl:text>
            <xsl:if test="@ed">
               <xsl:text> </xsl:text>
               <xsl:value-of select="translate(@ed,'#','')" />
            </xsl:if>
         </xsl:attribute>
      </br>
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
         <xsl:if test="$notesFormat != 'popup'">
            <xsl:attribute name="style">
               <xsl:text>display: none;</xsl:text>
            </xsl:attribute>
         </xsl:if>
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
      <!-- RB del <xsl:variable name="uniqueID" select="generate-id()" />  -->
      <xsl:variable name="uniqueID">
         <xsl:choose>
            <xsl:when test="@loc">
               <xsl:value-of select="@loc"/>
            </xsl:when>
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
      
      <!-- tei:rdg[contains(@wit, $refID)] -->
         <!-- <xsl:if test="contains(@wit, concat('#',$witID))"> -->
      
      <div>
         <xsl:if test="tei:rdg[contains(@wit, $refID)]/tei:timeline/tei:when"><!-- has to change ??? -->
            <xsl:for-each select="tei:rdg[contains(@wit, $refID)]/tei:timeline/tei:when">
<!--  MDH: Change to the way we deal with @absolute: it may not even be there.            -->
<!--              <xsl:if test="not(@absolute)">-->
               <xsl:if test="@since">
                  <xsl:attribute name="data-timeline">
                     <xsl:value-of select="translate(@since,'#','')" />
                  </xsl:attribute> 
               </xsl:if>  
            </xsl:for-each>
         </xsl:if>
         <xsl:attribute name="class">
            <xsl:text>apparatus</xsl:text>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$uniqueID"></xsl:value-of>
          <!--  <xsl:if test="@type">
               <xsl:text> type-</xsl:text>
               <xsl:value-of select="@type" />
            </xsl:if>-->
            <xsl:if test="parent::tei:app/@loc">
               <xsl:text> app-</xsl:text>
               <xsl:value-of select="parent::tei:app/@loc" />
            </xsl:if>
            <!--<xsl:if test="count(ancestor::tei:l) = 0">
               <xsl:text> app-</xsl:text>
               <xsl:value-of select="$uniqueID" />
               <xsl:text> clickable</xsl:text>
            </xsl:if>-->
         </xsl:attribute>
         <!--DC
         <xsl:if test="count(ancestor::tei:l) = 0">
         -->   
         
         <xsl:attribute name="onclick">
            <xsl:text>matchApp('</xsl:text>
            <xsl:value-of select="$uniqueID" />
            <xsl:text>');</xsl:text> 
         </xsl:attribute>

            <!--DC-->
            <!-- RB  <xsl:choose>
               <xsl:when test="parent::tei:app/@loc"> 
                  <xsl:attribute name="onclick">
                     <xsl:text>matchLine(this.className);</xsl:text>
                  </xsl:attribute>
                  </xsl:when> -->
         <!--<xsl:otherwise> ??? not sure if otherwise is necessary 
                  <xsl:attribute name="onclick">
                     <xsl:text>matchApp('app-</xsl:text>
                        <xsl:value-of select="$uniqueID" />
                        <xsl:text>');</xsl:text> 
                  </xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>-->
            <!--/DC-->
   
         <!--DC
         </xsl:if>
         -->

         <xsl:apply-templates>
            <xsl:with-param name="witID" tunnel="yes" select="$witID"></xsl:with-param>
         </xsl:apply-templates>
      </div>
         <!-- </xsl:if> -->
      
   </xsl:template>
   
   <xsl:template match="tei:rdg|tei:lem">
      <xsl:param name="witID" tunnel="yes"></xsl:param>
      
      <xsl:if test="contains(@wit, concat('#',$witID))">
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
                  <xsl:apply-templates />
               </div>
            </xsl:when>
            <xsl:otherwise>
               <div>
                  <xsl:attribute name="class">rdg</xsl:attribute>
                  <xsl:attribute name="line-id"><xsl:value-of select="@wit"/></xsl:attribute>
                  <xsl:apply-templates />
               </div>
            </xsl:otherwise>
      </xsl:choose>
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
      <div class="panel imgPanel draggable resizable ui-widget-content ui-resizable" id="{$imgId}">
         
         <div title="Click to drag panel." class="viewerHandle" id="handle_imageViewer">
            <span class="viewerHandleLt" id="title_imageViewer">
            <xsl:value-of select="$imgUrl"></xsl:value-of>
            </span>
            <img class="viewerHandleRt closePanel" alt="X" src="../vm-images/closePanel.gif" />
         </div>
         <div class="viewerContent" id="content_imageViewer">
            <!-- RB: jquery.panzoom plugin from https://github.com/timmywil/jquery.panzoom The links to the JS and CSS files are in the facsimile template-->
            
            <xsl:variable name="img-container-id">panzoom<xsl:value-of select="$imgId"/></xsl:variable>
            <xsl:element name="div">
               <xsl:attribute name="class">section</xsl:attribute>
               <xsl:attribute name="id"><xsl:value-of select="$img-container-id"/></xsl:attribute>
               
               
               <div class="panzoom-parent">
            <!-- zoom control -->
            <div class="buttons">
                     <button class="zoom-in">+</button>
                     <button class="zoom-out">-</button>
                     <input type="range" class="zoom-range"/>
                     <button class="reset">Reset</button>
                  </div>
            <!-- panzoom image -->
            <div class="panzoom">
                     <img width="200" border="1px 2px, 2px, 1px solid #000;" alt="image">
                        <xsl:attribute name="src">
                           <xsl:value-of select="$imgUrl" />
                        </xsl:attribute>
                        
                     </img>
                  </div>
               </div>
               
               <script  type="text/javascript">
                  (function() {
                  var $section = $(<xsl:text>'div#</xsl:text><xsl:value-of select="$img-container-id"/><xsl:text>'</xsl:text>);
                  $section.find('.panzoom').panzoom({
                  $zoomIn: $section.find(".zoom-in"),
                  $zoomOut: $section.find(".zoom-out"),
                  $zoomRange: $section.find(".zoom-range"),
                  $reset: $section.find(".reset")
                  });
                  })();
               </script>
               
            </xsl:element>
            <!-- End implementation of jquery.panzoom -->
         </div>
         <div class="panelFooter" height="25px">
            
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