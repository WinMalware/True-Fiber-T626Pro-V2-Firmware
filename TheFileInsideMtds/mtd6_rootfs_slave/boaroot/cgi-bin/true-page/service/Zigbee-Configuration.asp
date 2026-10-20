<%
if Request_Form("Zigbee_Flag") = "1" then
    TCWebApi_set("Zigbee_Common","Active","Enable_Flag")
    TCWebApi_set("Zigbee_Common", "resetZigbee", "resetZigbee_Flag")
    TCWebApi_set("Zigbee_Common", "unactiveZigbee", "unactiveZigbee_Flag")
    TCWebApi_commit("Zigbee_Common")
    tcWebApi_save()
end if
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html lang="en" style="overflow: hidden;">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Zigbee Configuration</title>
  <!-- style -->
  <link rel="stylesheet" href="/css/bootstrap.min.css">
  <link rel="stylesheet" href="/css/style.min.css">
  <!-- style -->

  <!-- script -->
  <script src="/scripts/lib/jquery.min.js"></script>
  <script src="/scripts/lib/bootstrap.min.js"></script>
  <script src="/scripts/lib/bootstrap.bundle.min.js"></script>
  <script src="/scripts/utils/util_skyw.js"></script>
<%if Request_Form("SaveAlter_Flag") = "1" then %>
  <script language=JavaScript type="text/javascript">
    var Tips = applyAlert({
      "content": "submit successful.",
      "buttons":{
      },
      "autoClose": 2
    });
  </script>
<% end if %>
  <!-- script -->
</head>

<body onload="LoadFrame()">
<!-- content -->
  <div >
      <div class="container-full container-resize-height">
          <div class="title-text">Zigbee Configuration</div>
          <div class="title-description-text">This page is used to configure Zigbee. </div>
          <FORM name="ConfigForm" action="/cgi-bin/true-page/service/Zigbee-Configuration.asp" method="post">
          <input TYPE="hidden" NAME="SaveAlter_Flag" VALUE="0">
          <input TYPE="hidden" NAME="Action_Flag" VALUE="0">
                    <div class="row p-1">
                        <div class="col-6">
                            <div class="title-text-left">Enable Zigbee :</div>
                        </div>
                        <div class="col-6">
                            <input id=Enable type=checkbox name="Enable" onclick="zigbeeEnableChange()" <%if tcWebApi_get("Zigbee_Common","Active","h") <> "No" then asp_Write("checked") end if%> >
                        </div>
                    </div>
                    <div class="row p-1" id="zigbee-unactive" >
                      <div class="col-6">
                        <div class="title-text-left">Unactive Zigbee:</div>
                      </div>
                      <div class="col-6 left">
                        <button class="btn-file" type="button" id="unactiveZigbee" onClick="unactiveZigbeeClick()">Unactive Zigbee</button>
                      </div>
                    </div>
                    <div class="row p-1" id="zigbee-reset" >
                      <div class="col-6">
                        <div class="title-text-left">Reset Zigbee:</div>
                      </div>
                      <div class="col-6 left">
                        <button class="btn-file" type="button" id="resetZigbee" onClick="resetZigbeeClick()">Reset Zigbee</button>
                      </div>
                    </div>
                    <div>
                            <input type="hidden" name="Zigbee_Flag" value="0">
                            <input type="hidden" name="unactiveZigbee_Flag" value="0">
                            <input type="hidden" name="resetZigbee_Flag" value="0">
                            <input type="hidden" name="updateZigbeeList_Flag" value="0">
                            <input type="hidden" name="Enable_Flag" value="<% tcWebApi_get("Zigbee_Common","Active","s") %>"> 
                                <script language=JavaScript type=text/javascript>
                                
                                    
                                    function btnSaveZigbee()
                                    {
                                        if(document.ConfigForm.Enable.checked)
                                        {
                                            document.ConfigForm.Enable_Flag.value = "Yes";
                                        }
                                        else
                                        {
                                            document.ConfigForm.Enable_Flag.value = "No";
                                        }
                                        document.ConfigForm.SaveAlter_Flag.value = "1";
                                        document.ConfigForm.Zigbee_Flag.value = "1";
                                        document.ConfigForm.submit();
                                    }

                                    function unactiveZigbeeClick()
                                    {
                                        document.ConfigForm.unactiveZigbee_Flag.value = "1";
                                        //document.ConfigForm.Zigbee_Flag.value = "1";
                                        //document.ConfigForm.Action_Flag.value = "1";
                                        btnSaveZigbee()
                                    }

                                    function resetZigbeeClick()
                                    {
                                        document.ConfigForm.resetZigbee_Flag.value = "1";
                                        //document.ConfigForm.Zigbee_Flag.value = "1";
                                        //document.ConfigForm.Action_Flag.value = "1";
                                        btnSaveZigbee()
                                    }

                                    function zigbeeEnableChange()
                                    {
                                        var zigbeeEnable = getCheckVal('Enable');
                                    
                                        if ( 1 == zigbeeEnable )
                                        {
                                            document.getElementById("zigbee-reset").style.display = "";
                                            document.getElementById("zigbee-unactive").style.display = "";
                                        }
                                        else
                                        {
                                            document.getElementById("zigbee-reset").style.display = "none";
                                            document.getElementById("zigbee-unactive").style.display = "none";
                                        }
                                    }

                                    function RefreshPage(){
                                        location.reload()
                                    }
                                    

                                    function showHideMeshMenu() {
                                      var Enable_Flag = '<%tcWebApi_get("Zigbee_Common","Active","s")%>';
                                      if(Enable_Flag == "No"){
                                        document.getElementById("zigbee-reset").style.display = "none";
                                        document.getElementById("zigbee-unactive").style.display = "none";
                                      }else{
                                        document.getElementById("zigbee-reset").style.display = "";
                                        document.getElementById("zigbee-unactive").style.display = "";
                                      }
                                    }

                                    function postUpdateZigbeeList() {
                                        url = "/webapi/updateZigbeeList";
                                        $.ajax({
                                            url: url, 
                                            type: 'post',
                                            data:
                                            {
                                            },
                                            success: function(data){
                                            },
                                            error:function()
                                            {
                                            }
                                        });
                                    }

                                    function LoadFrame ()
                                    {
                                      showHideMeshMenu();
                                      postUpdateZigbeeList();
                                    }
                          </script>
                    </div>
           </FORM>     

          <div class="mt-2 center">
              <button type="button" class="btn-dashboard" id=btnOK onclick="btnSaveZigbee()">Apply Changes</button>
              <button type="button" class="btn-dashboard" id=refresh onclick="RefreshPage()">Apply Cancel</button>
          </div>

      </div>

  </div>
<!-- content -->
</body>

</html>
