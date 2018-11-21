<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/9/25
  Time: 13:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page isELIgnored="false" language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>hrms_main</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/jquery-easyui-1.3.3/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/jquery-easyui-1.3.3/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/jquery-easyui-1.3.3/demo/demo.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery-easyui-1.3.3/jquery.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
    <script type="text/javascript">
        var url;
        function addTab(url, text, iconCls) {
            var content = "<iframe frameborder=0 scrolling='auto' style='width:100%;height:100%' src='${pageContext.request.contextPath}/views/" + url + "'></iframe>";
            $("#tabs").tabs("add", {
                title : text,
                iconCls : iconCls,
                closable : true,
                content : content
            });
        }
        function openTab(text, url, iconCls) {
            if ($("#tabs").tabs("exists", text)) {
                $("#tabs").tabs("close", text);
                addTab(url, text, iconCls);
                $("#tabs").tabs("select", text);
            } else {
                addTab(url, text, iconCls);
            }
        }
        /* 退出 */
        function logout() {
            $.messager
                .confirm(
                    "系统提示",
                    "确定退出?",
                    function(r) {
                        if (r) {
                            window.location.href = "${pageContext.request.contextPath}/admin/logout";
                        }
                    });
        }
    </script>
    <style type="text/css">
        #jz{ margin:0 auto;}
        p.ex{
            color: #888888;
            font-size: 400%;
        }
    </style>
<body class="easyui-layout">
<div region="north" style="height: 78px; background-color: #ffff">
    <table width="100%">
        <tr>
            <td width="50%"></td>
            <td valign="bottom"
                style="font-size: 20px; color: #8B8B8B; font-family: '\u6977\u4f53',serif;"
                align="right" width="50%"><font size="3">&nbsp;&nbsp;<strong>当前管理员：</strong></font>
                <font color="red">${sessionScope.currentAdmin.username}</font>
            </td>

        </tr>
    </table>
</div>
<div region="center">
    <div class="easyui-tabs" fit="true" border="false" id="tabs">
        <div title="主页" data-options="iconCls:'icon-home'">
            <div align="center" style="padding-top: 50px">
                <p class="ex">人事管理系统</p>
            </div>
        </div>
    </div>
</div>
<div  region="west" style="width: 200px; height: 500px;" title="Menu" split="true">
    <div class="easyui-accordion">
        <div title="部门 "
             data-options="selected:true,iconCls:'icon-shujias'"
             style="padding: 10px; height: 10px;">
            <a href="javascript:openTab(' 部门信息','deptManage.jsp')"
               class="easyui-linkbutton" data-options="plain:true"
               style="width: 150px;"> 部门信息</a>
        </div>

        <div title="职位"
             data-options="selected:true,iconCls:'icon-schoolceo'"
             style="padding: 10px; height: 10px;">
            <a href="javascript:openTab(' 职务信息','positionManage.jsp')"
               class="easyui-linkbutton" data-options="plain:true"
               style="width: 150px;"> 职位信息</a>
        </div>

        <div title="员工" data-options="iconCls:'icon-students' "
             style="padding: 10px">
            <a href="javascript:openTab(' 员工信息','employeeManage.jsp')"
               class="easyui-linkbutton" data-options="plain:true"
               style="width: 150px;">员工信息</a>
        </div>

        <div title="公告"
             data-options="selected:true,iconCls:'icon-wenzhang'"
             style="padding: 10px; height: 10px;">
            <a href="javascript:openTab(' 公告信息 ','postManage.jsp')"
               class="easyui-linkbutton" data-options="plain:true"
               style="width: 150px;"> 公告信息</a>
        </div>

        <div title="系统" data-options="iconCls:'icon-item'"
             style="padding: 10px; border: none;">
            <a
                    href="javascript:openTab(' 管理员表','adminManage.jsp','icon-lxr')"
                    class="easyui-linkbutton"
                    data-options="plain:true,iconCls:'icon-lxr'" style="width: 150px;">
                    管理员列表</a>
            <a href="javascript:logout()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-exit'" style="width: 150px;">
                    退出</a>
        </div>
    </div>
</div>
</body>
</html>
