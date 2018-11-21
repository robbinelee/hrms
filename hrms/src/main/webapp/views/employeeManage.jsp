<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/9/25
  Time: 16:32
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
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript">
        var url;
        var firstDepartmentId;
        var firstDepartmentName;
        var firstPositionId;
        var firstPositionName;
        var submitDeptId;
        var submitPosId;
        var updateFlag;
        /* 根据条件查询员工 */
        function searchEmpl() {
            $("#dg").datagrid('load', {
                "id" : $("#e_id").val(),
                "name" : $("#e_name").val(),
                "department.name" : $("#e_dept").val(),
                "position.name" : $("#e_position").val(),
                "sex" : $("#e_sex").val()
            });
        }
        /* 删除员工，可以是多个 */
        function deleteEmpl() {
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
                    "Do you want to delete the <font color=red>"
                    + selectedRows.length + "</font> data?",
                    function(r) {
                        if (r) {
                            $
                                .post(
                                    "${pageContext.request.contextPath}/empl/delete",
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

        function openEmplAddDialog() {
            $("#dlg").dialog("open").dialog("setTitle", "添加新员工");
            $("#id").attr("readOnly", false);
            url = "${pageContext.request.contextPath}/empl/save";
            updateFlag = "no";
        }
        /* 保存员工，根据不同的 url 选择是添加还是修改 */
        function saveEmpl() {
            submitDeptId = $("#dept").combobox('getValue');
            submitPosId = $("#pos").combobox('getValue');
            $("#fm")
                .form(
                    "submit",
                    {
                        url : url + "?dept_id= " + submitDeptId
                            + "&pos_id= " + submitPosId
                            + "&updateFlag=" + updateFlag,
                        onSubmit : function() {
                            var msg = "";
                            // 进行输入信息的校验，非空，id 和 phone 的格式
                            if (!$(this).form("validate")) {
                                msg = "所有信息不能为空!";
                            } else if (!/^[0-9]+$/.test($("#id").val())) {
                                msg = "请输入id的数字类型!";
                            } else if (!/^1[3|5|7|8]\d{9}$/
                                .test($("#phone").val())) {
                                msg = "请输入正确的电话!";
                            }
                            if (msg != "") {
                                $.messager.alert("系统提示", msg);
                                return false;
                            } else {
                                return true;
                            }
                        },
                        success : function(data) {
                            var result = eval('(' + data + ')');
                            if (result.success) {
                                $.messager.alert("系统提示",
                                    "保存成功!");
                                resetValue();
                                $("#dlg").dialog("close");
                                $("#dg").datagrid("reload");
                            } else {
                                $.messager
                                    .alert("系统提示",
                                        "该id已经存在请输入新的id!");
                            }
                        }
                    });
        }

        function openEmplModifyDialog() {
            var selectedRows = $("#dg").datagrid('getSelections');
            if (selectedRows.length != 1) {
                $.messager.alert("系统提示", "请选择数据修改!");
                return;
            }
            var row = selectedRows[0];
            $("#dlg").dialog("open")
                .dialog("setTitle", "修改员工信息");
            $("#id").attr("readOnly", true);
            $('#fm').form('load', row);
            $('#birthday').datebox('setValue', row.birthday);
            $('#dept').combobox('setValue', row.department.id);
            $('#dept').combobox('setText', row.department.name);
            $('#pos').combobox('setValue', row.position.id);
            $('#pos').combobox('setText', row.position.name);
            url = "${pageContext.request.contextPath}/empl/save";
            updateFlag = "yes";
        }

        function resetValue() {
            $("#id").val("");
            $("#id").attr("readOnly", false);
            $("#name").val("");
            $('#sex').combobox('setValue', "male");
            $("#phone").val("");
            $("#email").val("");
            $("#address").val("");
            $('#education').combobox('setValue', "Bachelor");
            $('#birthday').datebox('setValue', formatterDate(new Date()));
            $('#dept').combobox('setValue', firstDepartmentId);
            $('#dept').combobox('setText', firstDepartmentName);
            $('#pos').combobox('setValue', firstPositionId);
            $('#pos').combobox('setText', firstPositionName);
        }

        function closeEmplDialog() {
            $("#dlg").dialog("close");
            resetValue();
        }
        /* 为部门的 combobox 设默认值 */
        $(document).ready(function() {
            $.ajax({
                url : '${pageContext.request.contextPath}/dept/getcombobox',
                type : 'post',
                success : function(data) {
                    if (data) {
                        $('#dept').combobox('setValue', data[0].id);
                        $('#dept').combobox('setText', data[0].name);
                        firstDepartmentId = data[0].id;
                        firstDepartmentName = data[0].name;
                    }
                }
            });
        });
        /* 为职位的 combobox 设默认值 */
        $(document).ready(function() {
            $.ajax({
                url : '${pageContext.request.contextPath}/position/getcombobox',
                type : 'post',
                success : function(data) {
                    if (data) {
                        $('#pos').combobox('setValue', data[0].id);
                        $('#pos').combobox('setText', data[0].name);
                        firstPositionId = data[0].id;
                        firstPositionName = data[0].name;
                    }
                }
            });
        });

        /* 设置 datebox 默认值为指定格式的当前日期 */
        formatterDate = function(date) {
            var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
            var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0"
                + (date.getMonth() + 1);
            return date.getFullYear() + '-' + month + '-' + day;
        };

        window.onload = function() {
            $('#birthday').datebox('setValue', formatterDate(new Date()));
        };
    </script>
</head>
<body style="margin: 1px;">
<table id="dg" title="员工管理" class="easyui-datagrid"
       fitColumns="true" pagination="true" rownumbers="true"
       url="${pageContext.request.contextPath}/empl/list" fit="true"
       toolbar="#tb">
    <thead>
    <tr>
        <th field="cb" checkbox="true" align="center"></th>
        <th field="id" width="50" align="center">id</th>
        <th field="name" width="80" align="center">姓名</th>
        <th field="sex" width="50" align="center">性别</th>
        <th field="phone" width="80" align="center">电话</th>
        <th field="email" width="100" align="center">邮箱</th>
        <th field="address" width="80" align="center">地址</th>
        <th field="education" width="60" align="center">学历</th>
        <th field="birthday" width="80" align="center">生日</th>
        <th field="department.id" width="50" align="center" hidden="true">部门id</th>
        <th field="department.name" width="80" align="center">部门</th>
        <th field="position.id" width="50" align="center" hidden="true">职位id</th>
        <th field="position.name" width="80" align="center">职位</th>
    </tr>
    </thead>
</table>
<div id="tb">
    <div>
        <a href="javascript:openEmplAddDialog()" class="easyui-linkbutton"
           iconCls="icon-add" plain="true">添加</a> <a
            href="javascript:openEmplModifyDialog()" class="easyui-linkbutton"
            iconCls="icon-edit" plain="true">修改</a> <a
            href="javascript:deleteEmpl()" class="easyui-linkbutton"
            iconCls="icon-remove" plain="true">删除</a>
    </div>
    <div>
        <table>
            <tr>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ID:&nbsp;
                    <input type="text" id="e_id" size="20"
                           onkeydown="if(event.keyCode==13) searchEmpl()" />
                </td>
                <td>&nbsp;姓名:&nbsp; <input type="text" id="e_name" size="20"
                                           onkeydown="if(event.keyCode==13) searchEmpl()" />
                </td>
                <td>&nbsp;部门:&nbsp; <input type="text" id="e_dept"
                                           size="20" onkeydown="if(event.keyCode==13) searchEmpl()" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;职位:&nbsp;
                    <input type="text" id="e_position"
                           size="20" onkeydown="if(event.keyCode==13) searchEmpl()" />
                </td>
                <td>&nbsp;性别:&nbsp; <input type="text"
                                           id="e_sex" size="20"
                                           onkeydown="if(event.keyCode==13) searchEmpl()" />
                </td>
                <td>&nbsp;&nbsp;&nbsp;<a href="javascript:searchEmpl()"
                                         class="easyui-linkbutton" iconCls="icon-search" plain="true">查询</a>
                </td>
            </tr>
        </table>
    </div>
</div>

<div id="dlg" class="easyui-dialog"
     style="width: 500px; height: 550px; padding: 10px 20px" closed="true"
     buttons="#dlg-buttons">
    <form id="fm" method="post">
        <table cellspacing="8px">
            <tr>
                <td>ID:</td>
                <td><input type="text" id="id" name="id" style="width: 210px"
                           class="easyui-validatebox"
                           data-options="required:true,validType:'digits'" />&nbsp;<font
                        color="red">*</font></td>
            </tr>
            <tr>
                <td>姓名:</td>
                <td><input type="text" id="name" name="name"
                           style="width: 210px" class="easyui-validatebox" required="true" />&nbsp;<font
                        color="red">*</font></td>
            </tr>
            <tr>
                <td>性别:</td>
                <td><select id="sex" class="easyui-combobox" name="sex"
                            style="width: 220px; heigth: 60px"
                            data-options="editable:false,panelHeight:'auto'">
                    <option>男</option>
                    <option>女</option>
                </select></td>
            </tr>
            <tr>
                <td>电话:</td>
                <td><input type="text" id="phone" name="phone"
                           style="width: 210px" class="easyui-validatebox" required="true" />&nbsp;<font
                        color="red">*</font></td>
            </tr>
            <tr>
                <td>邮箱:</td>
                <td><input type="text" id="email" name="email"
                           style="width: 210px" class="easyui-validatebox"
                           data-options="required:true,validType:'email'" />&nbsp;<font
                        color="red">*</font></td>
            </tr>
            <tr>
                <td>地址:</td>
                <td><textarea id="address" name="address"
                              style="width: 210px; height: 50px" class="easyui-validatebox"
                              required="true"></textarea>&nbsp;<font color="red">*</font></td>
            </tr>
            <tr>
                <td>学历:</td>
                <td><select id="education" class="easyui-combobox"
                            name="education" style="width: 220px; heigth: 60px"
                            data-options="editable:false,panelHeight:'auto'">
                    <option>Bachelor</option>
                    <option>Master</option>
                    <option>Doctor</option>
                </select></td>
            </tr>
            <tr>
                <td>生日:</td>
                <td><input id="birthday" name="birthday" type="text"
                           class="easyui-datebox" data-options="editable:false"
                           required="required" style="width: 220px"></td>
            </tr>
            <tr>
                <td>部门:</td>
                <td><select class="easyui-combobox" id="dept" name="dept"
                            data-options="url:'${pageContext.request.contextPath}/dept/getcombobox',
                                           method:'post',
                                           valueField:'id',
                                           textField:'name',
                                           editable:false,
                                           panelHeight:'auto'"
                            style="width: 220px"></select></td>
            </tr>
            <tr>
                <td>职务:</td>
                <td><select class="easyui-combobox" id="pos" name="pos"
                            data-options="url:'${pageContext.request.contextPath}/position/getcombobox',
                                           method:'post',
                                           valueField:'id',
                                           textField:'name',
                                           editable:false,
                                           panelHeight:'auto'"
                            style="width: 220px"></select></td>
            </tr>

        </table>
    </form>
</div>


<div id="dlg-buttons">
    <a href="javascript:saveEmpl()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
    <a href="javascript:closeEmplDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
</div>
</body>
</html>