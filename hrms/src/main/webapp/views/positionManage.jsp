<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/9/25
  Time: 16:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page isELIgnored="false" language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/jquery-easyui-1.3.3/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/jquery-easyui-1.3.3/themes/icon.css">
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery-easyui-1.3.3/jquery.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
    <script type="text/javascript">
        var url;
        /* 根据条件查询职位 */
        function searchPosition() {
            $("#dg").datagrid('load', {
                "name" : $("#s_name").val()
            });
        }
        /* 删除职位，可以是多个 */
        function deletePosition() {
            var selectedRows = $("#dg").datagrid('getSelections');
            if (selectedRows.length == 0) {
                $.messager.alert("系统提示",
                    "请选择数据删除!");
                return;
            }
            var strIds = [];
            for ( var i = 0; i < selectedRows.length; i++) {
                strIds.push(selectedRows[i].id);
            }
            var ids = strIds.join(",");
            $.messager
                .confirm(
                    "系统提示",
                    "确定要删除 <font color=red>"
                    + selectedRows.length + "</font> 数据?",
                    function(r) {
                        if (r) {
                            $
                                .post(
                                    "${pageContext.request.contextPath}/position/delete",
                                    {
                                        ids : ids
                                    },
                                    function(result) {
                                        if (result.success) {
                                            $.messager
                                                .alert(
                                                    "系统提示",
                                                    "删除成功!");
                                            $("#dg").datagrid(
                                                "reload");
                                        } else {
                                            $.messager
                                                .alert(
                                                    "系统提示",
                                                    "删除失败，该职位还有员工!");
                                        }
                                    }, "json");
                        }
                    });
        }

        function openPositionAddDialog() {
            $("#dlg").dialog("open").dialog("setTitle", "添加新的职位");
            url = "${pageContext.request.contextPath}/position/save";
        }
        /* 保存职位，根据不同的 url 选择是添加还是修改 */
        function savePosition() {
            $("#fm").form("submit", {
                url : url,
                onSubmit : function() {
                    return $(this).form("validate");
                },
                success : function(result) {
                    $.messager.alert("系统提示", "保存成功!");
                    resetValue();
                    $("#dlg").dialog("close");
                    $("#dg").datagrid("reload");
                }
            });
        }

        function openPositionModifyDialog() {
            var selectedRows = $("#dg").datagrid('getSelections');
            if (selectedRows.length != 1) {
                $.messager.alert("系统提示", "请选择数据修改!");
                return;
            }
            var row = selectedRows[0];
            $("#dlg").dialog("open")
                .dialog("setTitle", "修改职务信息");
            $('#fm').form('load', row);
            url = "${pageContext.request.contextPath}/position/save?id=" + row.id;
        }

        function resetValue() {
            $("#name").val("");
            $("#description").val("");
        }

        function closePositionDialog() {
            $("#dlg").dialog("close");
            resetValue();
        }
    </script>
</head>
<body style="margin: 1px;">
<table id="dg" title="职务管理" class="easyui-datagrid"
       fitColumns="true" pagination="true" rownumbers="true"
       url="${pageContext.request.contextPath}/position/list" fit="true"
       toolbar="#tb">
    <thead>
    <tr>
        <th field="cb" checkbox="true" align="center"></th>
        <th field="id" width="50" align="center" hidden="true">id</th>
        <th field="name" width="80" align="center">名称</th>
        <th field="description" width="200" align="center">描述</th>
    </tr>
    </thead>
</table>
<div id="tb">
    <div>
        <a href="javascript:openPositionAddDialog()"
           class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a> <a
            href="javascript:openPositionModifyDialog()"
            class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
        <a href="javascript:deletePosition()" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true">删除</a>
    </div>
    <div>
        &nbsp;名称:&nbsp;<input type="text" id="s_name" size="20"
                              onkeydown="if(event.keyCode==13) searchPosition()" /> <a
            href="javascript:searchPosition()" class="easyui-linkbutton"
            iconCls="icon-search" plain="true">查询</a>
    </div>
</div>

<div id="dlg" class="easyui-dialog"
     style="width: 450px; height: 250px; padding: 10px 20px" closed="true"
     buttons="#dlg-buttons">
    <form id="fm" method="post">
        <table cellspacing="8px">
            <tr>
                <td>名称:</td>
                <td><input type="text" id="name" name="name"
                           style="width: 180px" class="easyui-validatebox" required="true" />&nbsp;<font
                        color="red">*</font></td>
            </tr>
            <tr>
                <td>描述:</td>
                <td><textarea id="description" name="description"
                              style="width: 180px; height: 80px;" class="easyui-validatebox"
                              required="true"></textarea>&nbsp;<font color="red">*</font></td>
            </tr>
        </table>
    </form>
</div>

<div id="dlg-buttons">
    <a href="javascript:savePosition()" class="easyui-linkbutton"
       iconCls="icon-ok">保存</a> <a href="javascript:closePositionDialog()"
                                   class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
</div>
</body>
</html>
