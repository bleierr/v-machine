<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:variable name="indexPage">../samples.html</xsl:variable>
    
    <xsl:variable name="vmLogo">../vm-images/LogoSilver.png</xsl:variable>
    
    <xsl:variable name="menuIcon">../vm-images/menuicon.png</xsl:variable>
    
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
  <xsl:variable name="jsUnderscore">../src/js/underscore-min.js</xsl:variable>
    
    
    <!-- The number of version/witness panels to be displayed initially -->
  <xsl:variable name="versionsVisible">3</xsl:variable>
    
    <!-- To change the VM so that the bibliographic information page does not
   appear at the initial load, change "true" to "false" below -->
    <xsl:variable name="displayBibInfo">true</xsl:variable>
    
    <!-- critical information should be encoded as tei:notesStmt/tei:note[@type='critIntro'] in the TEI files -->
  <!-- To change the VM so that the critical information page does not
   appear at the initial load, change "true" to "false" below -->
    <xsl:variable name="displayCritInfo">true</xsl:variable>
    
    <!-- To change the VM so that line numbers are hidden by default, change
  "true" to "false" below -->
    <xsl:variable name="displayLineNumber">true</xsl:variable>
  
    
    <xsl:variable name="displayNotesPanel">false</xsl:variable>
    
    
    <!-- To change the VM's default method of displaying notes, modify the
   following variable:
      - popup: Popup footnote icons
      - inline: Inline note viewer panel
      - none: Hide notes
   -->
    
    
    
   
    
    
    
    
    
</xsl:stylesheet>