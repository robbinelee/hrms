<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/9/25
  Time: 14:09
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
        /* 根据条件查询管理员 */
        function searchAdmin() {
            $("#dg").datagrid('load', {
                "username" : $("#s_username").val()
            });
        }
        /* 删除管理员，可以是多个 */
        function deleteAdmin() {
            var selectedRows = $("#dg").datagrid('getSelections');
            if (selectedRows.length == 0) {
                $.messager.alert("系统提示", "请选择数据删除!");
                return;
            }
            var strIds = new Array();
            for ( var i = 0; i < selectedRows.length; i++) {
                strIds.push(selectedRows[i].id);
            }
            var ids = strIds.join(",");
            $.messager.confirm(
                "系统提示",
                "你确定要删除 <font color=red>"
                + selectedRows.length + "</font> 条数据?",
                function(r) {
                    if (r) {
                        $
                            .post("${pageContext.request.contextPath}/admin/delete",
                                {
                                    ids : ids
                                },
                                function(result) {
                                    if (result.success) {
                                        $.messager.alert(
                                                "系统提示",
                                                "删除成功!");
                                        $("#dg").datagrid(
                                            "reload");
                                    } else {
                                        $.messager
                                            .alert(
                                                "系统提示",
                                                "不能删除超级管理员!");
                                    }
                                }, "json");
                    }
                });
        }

        function openAdminAddDialog() {
            $("#dlg").dialog("open").dialog("setTitle", "增加新的管理员");
            url = "${pageContext.request.contextPath}/admin/save";
        }
        /* 保存管理员，根据不同的 url 选择是添加还是修改 */
        function saveAdmin() {
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

        function openAdminModifyDialog() {
            var selectedRows = $("#dg").datagrid('getSelections');
            if (selectedRows.length != 1) {
                $.messager.alert("系统提示", "请选择进行修改!");
                return;
            }
            var row = selectedRows[0];
            if (row.id == 1) {
                $.messager.alert("系统提示",
                    "不能更改超级管理员!");
                return;
            }
            $("#dlg").dialog("open").dialog("setTitle", "修改管理员信息");
            $('#fm').form('load', row);
            $("#password").val("******");
            url = "${pageContext.request.contextPath}/admin/save?id=" + row.id;
        }

        function resetValue() {
            $("#username").val("");
            $("#password").val("");
        }

        function closeAdminDialog() {
            $("#dlg").dialog("close");
            resetValue();
        }
    </script>
</head>
<body style="margin: 1px;">
<table id="dg" title="管理员管理" class="easyui-datagrid"
       fitColumns="true" pagination="true" rownumbers="true"
       url="${pageContext.request.contextPath}/admin/list" fit="true"
       toolbar="#tb">
    <thead>
    <tr>
        <th field="cb" checkbox="true" align="center"></th>
        <th field="id" width="50" align="center">id</th>
        <th field="username" width="80" align="center">帐号</th>
        <th field="role_name" width="80" align="center">角色名称</th>
    </tr>
    </thead>
</table>
<div id="tb">
    <div>
        <a href="javascript:openAdminAddDialog()" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a>
        <a href="javascript:openAdminModifyDialog()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
        <a href="javascript:deleteAdmin()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
    </div>
    <div>
        &nbsp;帐号:&nbsp;<input type="text" id="s_username" size="20" onkeydown="if(event.keyCode==13) searchAdmin()" />
        <a href="javascript:searchAdmin()" class="easyui-linkbutton" iconCls="icon-search" plain="true">查询</a>
    </div>
</div>

<div id="dlg" class="easyui-dialog"
     style="width: 620px; height: 250px; padding: 10px 20px" closed="true"
     buttons="#dlg-buttons">
    <form id="fm" method="post">
        <table cellspacing="8px">
            <tr>
                <td>帐号:</td>
                <td><input type="text" id="username" name="username" class="easyui-validatebox" required="true" />&nbsp;
                    <font color="red">*</font></td>
            </tr>
            <tr>
                <td>密码:</td>
                <td><input type="text" id="password" name="password" class="easyui-validatebox" required="true" />&nbsp;
                    <font color="red">*</font></td>
            </tr>
            <tr>
                <td>角色名称:</td>
                <td><input type="text" id="role_name" name="role_name" class="easyui-validatebox" required="true" />&nbsp;
                    <font color="red">*</font></td>
            </tr>
        </table>
    </form>
</div>

<div id="dlg-buttons">
    <a href="javascript:saveAdmin()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
    <a href="javascript:closeAdminDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
</div>
</body>
</html>

