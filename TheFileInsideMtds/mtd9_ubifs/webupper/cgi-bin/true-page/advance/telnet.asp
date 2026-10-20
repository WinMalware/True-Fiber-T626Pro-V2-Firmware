<%
if Request_Form("SaveFlag") = "1" then
  TCWebApi_set("Account_TelnetEntry","Active","TelnetActive")
  TCWebApi_set("Account_TelnetEntry","telnet_port","TelnetPort")
  TCWebApi_set("Account_TelnetEntry","telnet_passwd","TelnetPassword")
  TCWebApi_set("Account_TelnetEntry","Interface","TelnetInterface")
  TCWebApi_commit("Account_TelnetEntry")

  TCWebApi_set("Firewall_Entry","lan_telnet_enable","LanTelnetEnable")
  TCWebApi_set("Firewall_Entry","wan_telnet_enable","WanTelnetEnable")
  TCWebApi_commit("Firewall_Entry")
  TCWebApi_save()
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html lang="en" style="overflow: hidden;">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Telnet Configuration</title>
  <!-- style -->
  <link rel="stylesheet" href="/css/bootstrap.min.css">
  <link rel="stylesheet" href="/css/style.min.css">
  <link rel="stylesheet" href="/css/main.css">
  <!-- script -->
  <script src="/scripts/lib/jquery.min.js"></script>
  <script src="/scripts/lib/bootstrap.min.js"></script>
  <script src="/scripts/lib/bootstrap.bundle.min.js"></script>
  <script src="/scripts/utils/util_skyw.js"></script>
<% if Request_Form("SaveFlag") = "1" then %>
  <script language="JavaScript" type="text/javascript">
    var Tips = applyAlert({
      "content": "Submit successful.",
      "buttons": {},
      "autoClose": 2
    });
  </script>
<% end if %>
</head>

<body>
  <!-- content -->
  <div>
    <div class="container-full container-resize-height">
      <div class="title-text">Telnet Configuration</div>
      <div class="title-description-text">
        This page is used to configure Telnet service settings, listening port, password, and interface access.
      </div>

      <form name="TelnetForm" method="POST" action="/cgi-bin/true-page/advance/telnet.asp">
        <input type="hidden" name="SaveFlag" value="1">

        <div class="row p-1">
          <div class="col-6">
            <div class="title-text-left">Telnet Service:</div>
          </div>
          <div class="col-6">
            <select class="form-control input-select" name="TelnetActive">
              <option value="Yes" <% if tcWebApi_get("Account_TelnetEntry","Active","h") = "Yes" then asp_Write("selected") end if %>>Enable</option>
              <option value="No" <% if tcWebApi_get("Account_TelnetEntry","Active","h") <> "Yes" then asp_Write("selected") end if %>>Disable</option>
            </select>
          </div>
        </div>

        <div class="row p-1">
          <div class="col-6">
            <div class="title-text-left">Telnet Port:</div>
          </div>
          <div class="col-6">
            <input class="form-control input-textfield" type="text" name="TelnetPort" maxlength="5" value="<% if tcWebApi_get("Account_TelnetEntry","telnet_port","h") <> "N/A" then tcWebApi_get("Account_TelnetEntry","telnet_port","s") else asp_Write("23") end if %>">
          </div>
        </div>

        <div class="row p-1">
          <div class="col-6">
            <div class="title-text-left">Password:</div>
          </div>
          <div class="col-6">
            <input class="form-control input-textfield" type="password" name="TelnetPassword" value="<% if tcWebApi_get("Account_TelnetEntry","telnet_passwd","h") <> "N/A" then tcWebApi_get("Account_TelnetEntry","telnet_passwd","s") end if %>">
          </div>
        </div>

        <div class="row p-1">
          <div class="col-6">
            <div class="title-text-left">Interface Access:</div>
          </div>
          <div class="col-6">
            <select class="form-control input-select" name="TelnetInterface">
              <option value="LAN" <% if tcWebApi_get("Account_TelnetEntry","Interface","h") <> "WAN" then asp_Write("selected") end if %>>LAN Only</option>
              <option value="WAN" <% if tcWebApi_get("Account_TelnetEntry","Interface","h") = "WAN" then asp_Write("selected") end if %>>WAN Only</option>
            </select>
          </div>
        </div>

        <div class="row p-1">
          <div class="col-6">
            <div class="title-text-left">LAN Firewall Access:</div>
          </div>
          <div class="col-6">
            <select class="form-control input-select" name="LanTelnetEnable">
              <option value="1" <% if tcWebApi_get("Firewall_Entry","lan_telnet_enable","h") = "1" then asp_Write("selected") end if %>>Allow</option>
              <option value="0" <% if tcWebApi_get("Firewall_Entry","lan_telnet_enable","h") <> "1" then asp_Write("selected") end if %>>Block</option>
            </select>
          </div>
        </div>

        <div class="row p-1">
          <div class="col-6">
            <div class="title-text-left">WAN Firewall Access:</div>
          </div>
          <div class="col-6">
            <select class="form-control input-select" name="WanTelnetEnable">
              <option value="1" <% if tcWebApi_get("Firewall_Entry","wan_telnet_enable","h") = "1" then asp_Write("selected") end if %>>Allow</option>
              <option value="0" <% if tcWebApi_get("Firewall_Entry","wan_telnet_enable","h") <> "1" then asp_Write("selected") end if %>>Block</option>
            </select>
          </div>
        </div>

        <div class="mt-2 center">
          <button type="button" class="btn-dashboard" onclick="btnSaveTelnet()">Apply Changes</button>
          <button type="button" class="btn-dashboard" onclick="location.reload()">Apply Cancel</button>
        </div>
      </form>
    </div>
  </div>
  <!-- content -->

  <script language="JavaScript" type="text/javascript">
    function btnSaveTelnet() {
      var port = document.TelnetForm.TelnetPort.value.trim();
      if (!port || isNaN(port) || parseInt(port) < 1 || parseInt(port) > 65535) {
        if (typeof simpleAlert === 'function') {
          var alertTip = simpleAlert({
            "content": "Please enter a valid port number (1-65535).",
            "buttons": { "OK": function() { alertTip.close(); } }
          });
        } else {
          alert("Please enter a valid port number (1-65535).");
        }
        return false;
      }
      if (typeof showLoading === 'function') {
        showLoading();
      }
      document.TelnetForm.submit();
    }
  </script>
</body>

</html>
