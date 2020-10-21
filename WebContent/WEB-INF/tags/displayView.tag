<%--
    Mango - Open Source M2M - http://mango.serotoninsoftware.com
    Copyright (C) 2006-2011 Serotonin Software Technologies Inc.
    @author Matthew Lohbihler
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see http://www.gnu.org/licenses/.
--%><%@include file="/WEB-INF/tags/decl.tagf"%><%--
--%><%@tag body-content="empty"%><%--
--%><%@attribute name="view" type="com.serotonin.mango.view.View" required="true" rtexprvalue="true"%><%--
--%><%@attribute name="emptyMessageKey" required="true"%>
	<%@attribute name="reports" required="true" type="java.util.Map" %>

<tag:page dwr="ReportsDwr" showHeader="false" showMenu="false">
<script type="text/javascript">
	function imprimir(reportInstance) {
		if(reportInstance == null){
			alert("Ainda não foi gerado relatório para o modelo");
		} else {
	        var pathRelatorio = "reportChart.shtm?instanceId=" + reportInstance.id;
	        var janela = window.open(pathRelatorio);
	        janela.onload = function(){
	            janela.print();
	            setTimeout(function(){ janela.close(); }, 100);
	        };
		}		
	}
	
	function imprimirUltimoRelatorio(reportId) {
		var reportInstance = ReportsDwr.getLastReportInstanceByAdmin(reportId, imprimir);
	}
</script>
<div id="viewContent">
  <c:choose>
    <c:when test="${empty view}">
    	<c:if test="${sessionUser.admin || userAddedViews}">
    		<fmt:message key="${emptyMessageKey}"/>
    	</c:if>
   	</c:when>
    	
    <c:when test="${empty view.backgroundFilename}">
      <img id="viewBackground" src="images/spacer.gif" alt="" width="100%"/>
    </c:when>
    <c:otherwise>
      <img id="viewBackground" src="${view.backgroundFilename}" alt="" width="100%"/>
    </c:otherwise>
  </c:choose>
  
  <c:forEach items="${view.viewComponents}" var="vc">
    <!-- vc ${vc.id} -->
    <c:choose>
      <c:when test="${!vc.visible}"><!-- vc ${vc.id} not visible --></c:when>
      
      <c:when test="${vc.defName == 'simpleCompound'}">
        <div id="c${vc.id}" style="position:absolute;left:${vc.x}px;top:${vc.y}px;"
                  onmouseover="vcOver('c${vc.id}', 5);" onmouseout="vcOut('c${vc.id}');">
          <tag:pointComponent vc="${vc.leadComponent}"/>
          <c:choose>
            <c:when test="${empty vc.backgroundColour}"><c:set var="bkgd"></c:set></c:when>
            <c:otherwise><c:set var="bkgd">background:${vc.backgroundColour};</c:set></c:otherwise>
          </c:choose>
          <div id="c${vc.id}Controls" class="controlContent" style="left:5px;top:5px;${bkgd}">
            <b>${vc.name}</b><br/>
            <c:forEach items="${vc.childComponents}" var="child">
              <c:if test="${child.viewComponent.visible && child.viewComponent.id != vc.leadComponent.id}">
                <tag:pointComponent vc="${child.viewComponent}"/>
              </c:if>
            </c:forEach>
          </div>
        </div>
      </c:when>
      
      <c:when test="${vc.defName == 'imageChart'}">
        <div id="c${vc.id}" style="position:absolute;left:${vc.x}%;top:${vc.y}%;width:${Math.floor(100*vc.width/1100)}%"
                  onmouseover="vcOver('c${vc.id}', 10);" onmouseout="vcOut('c${vc.id}');">
          <div id="c${vc.id}Content" style="width:100%"><img src="images/icon_comp.png" width="100%" alt=""/></div>
          <div id="c${vc.id}Controls" class="controlContent">
            <div id="c${vc.id}Info">
              <tag:img png="hourglass" title="common.gettingData"/>
            </div>
          </div>
        </div>
      </c:when>
      
      <c:when test="${vc.compoundComponent}">
        <div id="c${vc.id}" style="position:absolute;left:${vc.x}px;top:${vc.y}px;"
                  onmouseover="vcOver('c${vc.id}', 5);" onmouseout="vcOut('c${vc.id}');">
          ${vc.staticContent}
          <div id="c${vc.id}Controls" class="controlsDiv">
            <table cellpadding="0" cellspacing="1">
              <tr onmouseover="showMenu('c${vc.id}Info', 16, 0);" onmouseout="hideLayer('c${vc.id}Info');"><td>
                <tag:img png="information"/>
                <div id="c${vc.id}Info" onmouseout="hideLayer(this);">
                  <tag:img png="hourglass" title="common.gettingData"/>
                </div>
              </td></tr>
              <c:if test="${vc.displayImageChart}">
                <tr onmouseover="mango.view.showChart('${vc.id}', event, this);" 
                        onmouseout="mango.view.hideChart('${vc.id}', event, this);"><td>
                  <img src="images/icon_chart.png" alt=""/>
                  <div id="c${vc.id}ChartLayer"></div>
                  <textarea style="display:none;" id="c${vc.id}Chart"><tag:img png="hourglass" title="common.gettingData"/></textarea>
                </td></tr>
              </c:if>
            </table>
          </div>
          <c:forEach items="${vc.childComponents}" var="child">
            <c:if test="${child.viewComponent.visible}"><tag:pointComponent vc="${child.viewComponent}"/></c:if>
          </c:forEach>
        </div>
      </c:when>
      
      <c:when test="${vc.defName == 'report'}">
        <div id="c${vc.id}" style="position:absolute;left:${vc.x}px;top:${vc.y}px;"
                  onmouseover="vcOver('c${vc.id}', 10);" onmouseout="vcOut('c${vc.id}');">
          <div id="c${vc.id}Content" style="text-align: center;">
          	<span>${reports[vc.content].name}</span>
          	<img style="margin: auto;" src="images/report.png" alt=""/>
          </div>
          <div id="c${vc.id}Controls" class="controlContent">
            <div id="c${vc.id}Info">              
              <button onclick="imprimirUltimoRelatorio(${vc.content})">Imprimir Relatório</button>
            </div>
          </div>
        </div>
      </c:when>      
      
      <c:otherwise><tag:pointComponent vc="${vc}"/></c:otherwise>
    </c:choose>
  </c:forEach>
</div>
</tag:page>
<style>

</style>
