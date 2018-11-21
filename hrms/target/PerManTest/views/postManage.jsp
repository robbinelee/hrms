<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/9/25
  Time: 15:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page isELIgnored="false" language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>postManage</title>
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/jquery-easyui-1.3.3/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/jquery-easyui-1.3.3/themes/icon.css">
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery-easyui-1.3.3/jquery.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/ueditor/ueditor.config.js">

    </script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/ueditor/ueditor.all.min.js ">

    </script>
    <script type="text/javascript" charset="utf-8" src="/ueditor/lang/zh-cn/zh-cn.js">

    </script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/js/common.js"></script>
    <script type="text/javascript">
        var url;
        function ResetEditor() {
            UE.getEditor('myEditor', {
                initialFrameHeight : 480,
                initialFrameWidth : 660,
                enableAutoSave : false,
                elementPathEnabled : false,
                wordCount : false,

            });
        }
        /* 根据条件查询公告 */
        function searchPost() {
            $("#dg").datagrid('load', {
                "title" : $("#postTitle").val(),
            });
        }
        /* 删除公告，可以是多个 */
        function deletePost() {
            var selectedRows = $("#dg").datagrid('getSelections');
            if (selectedRows.length == 0) {
                $.messager.alert("系统提示", "请选择修改数据!");
                return;
            }
            var strIds = [];
            for ( var i = 0; i < selectedRows.length; i++) {
                strIds.push(selectedRows[i].id);
            }
            var ids = strIds.join(",");
            $.messager
                .confirm(
                    "请选择删除数据!",
                    "确定要删除 <font color=red>"
                    + selectedRows.length + "</font> 数据?",
                    function(r) {
                        if (r) {
                            $
                                .post(
                                    "${pageContext.request.contextPath}/post/delete",
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
                                                    "删除失败!");
                                        }
                                    }, "json");
                        }
                    });

        }

        function openPostAddDialog() {
            var html = '<div id="myEditor" name="content"></div>';
            $('#editor').append(html);
            ResetEditor(editor);
            var ue = UE.getEditor('myEditor');
            ue.ready(function() {
                ue.setContent("");
            });

            $("#dlg").dialog("open").dialog("setTitle", "添加公告");
            url = "${pageContext.request.contextPath}/post/save";

        }
        /* 保存公告，根据不同的 url 选择是添加还是修改 */
        function savePost() {
            $("#fm").form("submit", {
                url : url,
                onSubmit : function() {
                    return $(this).form("validate");
                },
                success : function(result) {
                    $.messager.alert("系统提示", "保存成功!");
                    $("#dlg").dialog("close");
                    $("#dg").datagrid("reload");
                    resetValue();
                }
            });
        }

        function openPostModifyDialog() {
            var selectedRows = $("#dg").datagrid('getSelections');
            if (selectedRows.length != 1) {
                $.messager.alert("系统提示", "请选择修改数据!");
                return;
            }
            var row = selectedRows[0];
            $("#dlg").dialog("open").dialog("setTitle", "Edit post");
            $('#fm').form('load', row);
            var html = '<div id="myEditor" name="content"></div>';
            $('#editor').append(html);
            ResetEditor(editor);
            var ue = UE.getEditor('myEditor');
            ue.ready(function() {
                ue.setContent(row.content);
            });

            url = "${pageContext.request.contextPath}/post/save?id=" + row.id;
        }

        function formatHref(val, row) {
            return "<a href='${pageContext.request.contextPath}/post/getById?id="
                + row.id + "' target='_blank'>内容</a>";
        }

        function resetValue() {
            $("#title").val("");
            $("#container").val("");
            ResetEditor();
        }

        function closePostDialog() {
            $("#dlg").dialog("close");
            resetValue();
        }
    </script>
</head>
<body style="margin: 1px;" id="ff">
<table id="dg" title="公告管理" class="easyui-datagrid"
       pagination="true" rownumbers="true" fit="true"
       data-options="pageSize:10"
       url="${pageContext.request.contextPath}/post/list" toolbar="#tb">
    <thead data-options="frozen:true">
    <tr>
        <th field="cb" checkbox="true" align="center"></th>
        <th field="id" width="10%" align="center" hidden="true">id</th>
        <th field="title" width="300" align="center">标题</th>
        <th field="date" width="150" align="center">创建时间</th>
        <th field="admin.username" width="150" align="center">宣告者</th>
        <th field="content" width="150" align="center"
            formatter="formatHref">操作</th>
    </tr>
    </thead>
</table>
<div id="tb">
    <div>
        <a href="javascript:openPostAddDialog()" class="easyui-linkbutton"
           iconCls="icon-add" plain="true">添加</a> <a
            href="javascript:openPostModifyDialog()" class="easyui-linkbutton"
            iconCls="icon-edit" plain="true">修改</a> <a
            href="javascript:deletePost()" class="easyui-linkbutton"
            iconCls="icon-remove" plain="true">删除</a>
    </div>
    <div>
        &nbsp;标题:&nbsp;<input type="text" id="postTitle" size="20"
                              onkeydown="if(event.keyCode==13) searchPost()" />&nbsp; <a
            href="javascript:searchPost()" class="easyui-linkbutton"
            iconCls="icon-search" plain="true">查询</a>
    </div>
</div>

<div id="dlg" class="easyui-dialog"
     style="width: 850px; height: 555px; padding: 10px 20px; position: relative; z-index: 1000;"
     closed="true" buttons="#dlg-buttons">
    <form id="fm" method="post">
        <table cellspacing="8px">
            <tr>
                <td>标题:</td>
                <td><input type="text" id="title" name="title"
                           class="easyui-validatebox" required="true" />&nbsp;<font
                        color="red">*</font></td>
            </tr>
            <tr>
                <td>内容:</td>
                <td id="editor"></td>
            </tr>
        </table>
    </form>
</div>

<div id="dlg-buttons">
    <a href="javascript:savePost()" class="easyui-linkbutton"
       iconCls="icon-ok">保存</a> <a href="javascript:closePostDialog()"
                                   class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
</div>
</body>
</html>