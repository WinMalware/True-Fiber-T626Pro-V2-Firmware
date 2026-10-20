<%
if Request_Form("updateZigbeeList_Flag") = "1" then
    TCWebApi_set("Zigbee_Common", "updateZigbeeList", "updateZigbeeList_Flag")
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

<body >
<!-- content -->
  <div >
      <div class="container-full container-resize-height">
          <div class="title-text">Zigbee Info</div>
          <div class="title-description-text">This page is used to show Zigbee Info. </div>
          <FORM name="ConfigForm" action="/cgi-bin/true-page/service/Zigbee-Info.asp" method="post">
          <input TYPE="hidden" NAME="SaveAlter_Flag" VALUE="0">
              <div>
                      <input type="hidden" name="updateZigbeeList_Flag" value="0">
                          <script language=JavaScript type=text/javascript>
                          
                              function RefreshPage(){
                                  document.ConfigForm.updateZigbeeList_Flag.value = "1";
                                  document.ConfigForm.submit();
                              }
                              
                    </script>
              </div>
          <div>
              <iframe id="zigbeeInfo_cgi" src="/cgi-bin/getZigbeeInfo.cgi" frameborder="0" width="100%" overflow-y="yes" scrolling="no" ></iframe>
          </div>
           </FORM>     
    <script>
        function resizeIframe() {
            var iframe = document.getElementById('zigbeeInfo_cgi');
            iframe.style.height = iframe.contentWindow.document.body.scrollHeight + 'px';
        }

        // 当 iframe 加载完成时调用 resizeIframe 函数
        document.getElementById('zigbeeInfo_cgi').onload = resizeIframe;
    </script>
          <div class="mt-2 center">
              <button type="button" class="btn-dashboard" id=refresh onclick="RefreshPage()">Refresh</button>
          </div>

      </div>

  </div>
<!-- content -->
</body>

</html>