<%
if tcWebApi_get("XPON_Common","web_role_flag","h") <> "0" then

if Request_Form("SaveFlag") = "1" then
  if Request_Form("UplinkMode") = "25G" then
    TCWebApi_constSet("Wan_Common", "TransMode", "Ethernet")
    TCWebApi_constSet("Vid_LanUp", "port", "0")
    TCWebApi_constSet("Vid_LanUp", "is25g", "1")
    TCWebApi_constSet("Vid_LanUp", "change", "1")
    TCWebApi_commit("Wan_Common")
    TCWebApi_commit("Vid_LanUp")
  elseif Request_Form("UplinkMode") = "PON" then
    TCWebApi_constSet("Wan_Common", "TransMode", "XPON")
    TCWebApi_constSet("Vid_LanUp", "port", "-1")
    TCWebApi_constSet("Vid_LanUp", "is25g", "0")
    TCWebApi_constSet("Vid_LanUp", "change", "1")
    TCWebApi_commit("Wan_Common")
    TCWebApi_commit("Vid_LanUp")
  end if

  TCWebApi_save()

  if Request_Form("RebootReq") = "1" then
    TCWebApi_set("System_Entry","reboot_type","1")
    TCWebApi_commit("System_Entry")
  end if
end if

end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html lang="en" style="overflow: hidden;">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Operation Mode - Uplink Configuration</title>
  <link rel="stylesheet" href="/css/bootstrap.min.css">
  <link rel="stylesheet" href="/css/style.min.css">
  <link rel="stylesheet" href="/css/main.css">
  <script src="/scripts/lib/jquery.min.js"></script>
  <script src="/scripts/lib/bootstrap.min.js"></script>
  <script src="/scripts/lib/bootstrap.bundle.min.js"></script>
  <script src="/scripts/utils/util_skyw.js"></script>
</head>
<body>
  <div class="container-full container-resize-height">
    <form name="ConfigForm" action="/cgi-bin/true-page/other/UplinkMode.asp" method="post">
    <input type="hidden" name="SaveFlag" value="0">
    <input type="hidden" name="RebootReq" value="0">

    <div class="title-text">Uplink Configuration</div>
    <div class="title-description-text">Configure the primary WAN uplink interface. LAN1-4 remain as dedicated Local LAN / EasyMesh backhaul ports.</div>

    <div class="row p-1">
      <div class="col-6">
        <div class="title-text-left">Uplink Port:</div>
      </div>
      <div class="col-6">
        <input type="radio" name="UplinkMode" id="Uplink_25G" value="25G">
        <label class="input-radio" for="Uplink_25G">2.5G LAN (EtherWAN)</label>
        <input type="radio" name="UplinkMode" id="Uplink_PON" value="PON">
        <label class="input-radio" for="Uplink_PON">Fiber GPON/EPON</label>
      </div>
    </div>

    <div class="mt-4 mb-3 center">
      <button type="button" class="btn-dashboard" onclick="btnSave()">Apply Changes</button>
    </div>
    </form>
  </div>

  <script>
    var initialUplink = "<% if tcWebApi_get("Wan_Common","TransMode","h") = "Ethernet" then asp_Write("25G") else asp_Write("PON") end if %>";

    $(document).ready(function() {
      if (initialUplink == "25G") {
        setCheck("Uplink_25G", 1);
        setCheck("Uplink_PON", 0);
      } else {
        setCheck("Uplink_25G", 0);
        setCheck("Uplink_PON", 1);
      }
    });

    function btnSave() {
      var selectedUplink = (document.getElementById("Uplink_25G").checked) ? "25G" : "PON";
      var uplinkChanged = (selectedUplink != initialUplink);

      if (uplinkChanged) {
        var warnAlert = simpleAlert({
          "closeAll": true,
          "content": "Uplink interface mode changed. The device will save settings and restart to apply hardware port remapping. Proceed?",
          "buttons": {
            "OK": function() {
              warnAlert.close();
              document.ConfigForm.RebootReq.value = "1";
              document.ConfigForm.SaveFlag.value = "1";
              document.ConfigForm.submit();
            },
            "Cancel": function() { warnAlert.close(); }
          }
        });
        return;
      }

      document.ConfigForm.SaveFlag.value = "1";
      document.ConfigForm.submit();
    }
  </script>
</body>
</html>
