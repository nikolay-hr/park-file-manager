<%--
  Created by IntelliJ IDEA.
  User: com
  Date: 2016-08-11
  Time: 오후 6:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<head>
    <title>:: 파일 탐색기 1.0::</title>
    <link rel="stylesheet" type="text/css" href="./css/default.css">
    <script src="./js/jquery/jquery-3.1.0.min.js"></script>
    <script type="text/javascript">

        $(document).ready(function() {

            // Handler for .ready() called.
            //alert('ready2');

            function getStatusCompleteHandler(data)
            {
                $("table.file-table > tbody > tr").remove();

                $("#btn-parent").attr("disabled" , data.isRoot);

                data.files.sort(function(item1 , item2){return item1.isFile - item2.isFile;}).forEach(function(item){

                    var newRow = $("<tr><td></td><td></td><td></td><td></td><td></td></tr>");
                    newRow.data("name" , item.name);
                    newRow.data("isFile" , item.isFile);


                    var checkBox = $("<input type='checkbox'>");

                    newRow.find("td:nth-child(1)").append(checkBox);


                    var itemImage = $("<img>");


                    if(item.isFile == false)
                        itemImage.attr("src" , "./image/folder.png");
                    else
                        itemImage.attr("src" , "./image/file.png");


                    newRow.find("td:nth-child(2)").append(itemImage);


                    var itemName = $("<span style='padding-left: 5px'></span>");
                    itemName.html(item.name);
                    //itemName.css("cursor" , "hand");

                    newRow.find("td:nth-child(2)").attr("class" , "file-name");
                    newRow.find("td:nth-child(2)").append(itemName);
                    //newRow.find("td:nth-child(2)").data("directory" , itemName);
                    newRow.find("td:nth-child(2)").click(function(event){

                        //alert( $(event.currentTarget).parent().data("isFile") );

                        var name = $(event.currentTarget).parent().data("name");

                        var isFile = $(event.currentTarget).parent().data("isFile");

                      // if(isFile)
                       //    $.post("./api/download" , {"name":name} , fu);
                        //else
                        if(isFile == false)
                        {
                           $.post("./api/child" , {"directory":name} , getStatusCompleteHandler);
                        }
                        else
                        {
                            $("#form-download > input[name='name']").attr("value" , name);
                            //$("#form-download-name").attr("value" , name);

                            $("#form-download").submit();
                            //form-download.tar
                            //form-download
                        }

                       //$.post("./api/child" , {"directory":$(event.currentTarget).data("directory")} , getStatusCompleteHandler);
                       //$.post("./api/child" , {"directory":directory} , getStatusCompleteHandler);
                    });


                    newRow.find("td:nth-child(3)").html(item.length);

                    $("table.file-table > tbody").append(newRow);
                });

                $("table.file-table > tbody > tr:even").addClass("even-class");
            };

            $("#btn-parent").click(function(event){
                $.post("./api/parent" , getStatusCompleteHandler);
            });

            $("#btn-home").click(function(event){
                $.post("./api/home" , getStatusCompleteHandler);
            });


            $("#form-upload").submit(function(event){
                $.ajax({
                    url:"./api/upload",
                    type:"post",
                    mimeType: "multipart/form-data",
                    contentType: false,
                    cache: false,
                    processData: false,
                    data: new FormData(this),
                    success:function(event){
                        $.post("./api/reload" , getStatusCompleteHandler);
                    }
                });

                event.preventDefault();
            });

            $.post("./api/home" , getStatusCompleteHandler);
        });



    </script>
</head>




<body>

    파일탐색기 1.0<br><br>

    <table class="file-table">

        <thead>
            <th style="width: 20px"></th>
            <th style="width: 200px">이름</th>
            <th style="width: 50px">크기</th>
            <th style="width: 50px">유형</th>
            <th style="width: 100px">날짜</th>
        </thead>
        <tbody>

        </tbody>



    </table>

    <br>
    <input id="btn-home" type="button" value="홈">
    <input id="btn-parent" type="button" value="상위폴더">
    <br>

    <form id="form-upload" action="./api/upload" method="post" target="temp-frame" enctype="multipart/form-data">
        <input type="file" name="file">
        <input type="submit" value="업로드">
    </form>
    </div>
    <br>
    제작자 : 박근영<br>
    본 프로그램은 GPL v3 라이센스의 보호받고 있습니다.

    <form id="form-download" action="./api/download" method="post" style="display: none" target="temp-frame">
        <input type="text" name="name">
    </form>

    <iframe name="temp-frame" style="display: none"></iframe>

</body>
</html>