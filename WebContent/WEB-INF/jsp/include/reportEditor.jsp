<%@ include file="/WEB-INF/jsp/include/tech.jsp" %>
<div id="reportEditorPopup" style="display:none;left:0px;top:0px;" class="windowDiv">
  <table cellpadding="0" cellspacing="0"><tr><td>
    <table width="100%">
      <tr>
        <td>
          <tag:img png="report" title="viewEdit.static.editor" style="display:inline;"/>
        </td>
        <td align="right">
          <tag:img png="save" onclick="reportEditor.save()" title="common.save" style="display:inline;"/>&nbsp;
          <tag:img png="cross" onclick="reportEditor.close()" title="common.close" style="display:inline;"/>
        </td>
      </tr>
    </table>
    <table id="reportEditor">
      <tr>
        <td class="formField">
          <select name="report" id="reportPointSelect">
              <c:forEach items="${reports}" var="report">
              <option value="${report.id}">${report.name}</option>
              </c:forEach>
          </select>
        </td>
      </tr>
    </table>
  </td></tr></table>
  
  <script type="text/javascript">
    function ReportEditor() {
        this.componentId = null;
        this.component = null;
        
        this.open = function(compId) {
            hide('reportEditor');
            
            reportEditor.componentId = compId;
            ViewDwr.getViewComponent(compId, function(comp) {
                // Update the data in the form.
                reportEditor.component = comp;
				if(comp.defName == 'report'){
					$set("reportPointSelect", comp.content);
					show('reportEditor');
		            show("reportEditorPopup");					
				}            
			});
            positionEditor(compId, "reportEditorPopup");
        };
        
        this.close = function() {
            hide("reportEditorPopup");
        };
        
        this.save = function() {
			if(reportEditor.component.defName == 'report') {
				ViewDwr.saveReportComponent(reportEditor.componentId, $get("reportPointSelect"), function() {
	                reportEditor.close();
	                updateReportComponentContent("c"+ reportEditor.componentId, $get("reportPointContent"));
	            });
			}			
        };

        this.updateViewsList = function(views) {
            dwr.util.removeAllOptions("viewsList");
            var sel = $("viewsList");
            sel.options[0] = new Option("", 0);
            for (var i=0; i<views.length; i++) {
                sel.options[i+1] = new Option(views[i].value, views[i].key);
            }
        };

        this.updateScriptsList = function(scripts) {
            dwr.util.removeAllOptions("scriptsList");
            var sel = $("scriptsList");
            for (var i=0; i<scripts.length; i++) {
                sel.options[i] = new Option(scripts[i].name, scripts[i].xid);
            }
        };

        this.updateFlexProjectsList = function(flexProjects) {
            dwr.util.removeAllOptions("flexProjectsList");
            var sel = $("flexProjectsList");
            for (var i=0; i<flexProjects.length; i++) {
                sel.options[i] = new Option(flexProjects[i].name, flexProjects[i].id);
            }
        };
        
        this.viewSelectChanged = function(value) {
        	$set("linkLink","");
            if(value!=0) {
            	link = getAbsolutePath()+"views.shtm?viewId="+value;
                $set("linkLink",link);
            }
        };
    }

    function getAbsolutePath() {
        var loc = window.location;
        var pathName = loc.pathname.substring(0, loc.pathname.lastIndexOf('/') + 1);
        return loc.href.substring(0, loc.href.length - ((loc.pathname + loc.search + loc.hash).length - pathName.length));
    }
        
    var reportEditor = new ReportEditor();
  </script>
</div>