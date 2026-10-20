<%
if tcWebApi_get("XPON_Common","web_role_flag","h") <> "0" then
 
if Request_Form("SaveFlag") = "1" then
  TCWebApi_Set("WLan_Entry0", "EnableSSID", "MapEnable")
  TCWebApi_Set("WLan11ac_Entry0", "EnableSSID", "MapEnable")

  if Request_Form("MapEnable") = "1" then
    TCWebApi_constSet("Mesh_EnableConf", "EasyMeshEnable","1")
    TCWebApi_constSet("Mesh_EnableConf", "BandSteeringEnable","0")
    TCWebApi_constSet("Mesh_dat", "MapEnable","1")
  else
    TCWebApi_constSet("Mesh_Common", "DeviceRole","1")
    TCWebApi_constSet("MeshRoleExchange_Entry", "MeshRole","1")
    TCWebApi_constSet("Mesh_EnableConf", "EasyMeshEnable","0")
    TCWebApi_constSet("Mesh_EnableConf", "BandSteeringEnable","1")
    TCWebApi_constSet("Mesh_dat", "MapEnable","0")
  end if

  if Request_Form("OtherToAgent") = "1" then
    TCWebApi_constSet("Dhcp6s_Entry", "Enable", "0")
    TCWebApi_constSet("Radvd_Entry", "Enable", "0")
    TCWebApi_commit("Radvd_Entry")
    TCWebApi_commit("Dhcp6s_Entry")
    TCWebApi_save("Radvd_Entry")
    TCWebApi_save("Dhcp6s_Entry")
  end if

  if Request_Form("deviceRoleChange_Flag") = "1" then
    TCWebApi_Set("MeshRoleExchange_Entry", "MeshRole", "DeviceRole")
    TCWebApi_Set("Mesh_common", "DeviceRole", "DeviceRole")

    if Request_Form("DeviceRole") = "0" then
      TCWebApi_constSet("Mesh_common","DeviceRole","1")
      TCWebApi_unset("Mesh_apclibh_Entry0")
      TCWebApi_unset("Mesh_apclibh_Entry1")
    end if

    if Request_Form("DeviceRole") = "2" then
      TCWebApi_constSet("Account_Entry0","display_mask","2E FF 35 5C 00 00 37 00 FF")
      TCWebApi_constSet("Account_Entry1","display_mask","2E FF 25 4C 00 00 17 00 FF")
    else
      TCWebApi_constSet("Account_Entry0","display_mask","FF FF FF FF FF BF FF FF FF")
      TCWebApi_constSet("Account_Entry1","display_mask","BF 00 0F CC FF 87 17 00 01")
    end if

    if tcwebApi_get("WebCurSet_Entry","CurrentAccess","h") = "0" then
      TCWebApi_constSet("Account_Entry0","Logged","0")
      TCWebApi_constSet("Account_Entry0","Logoff","1")
    else
      TCWebApi_constSet("Account_Entry1","Logged","0")
      TCWebApi_constSet("Account_Entry1","Logoff","1")
    end if

    TCWebApi_commit("Account")
    TCWebApi_commit("Mesh_apclibh")
  end if

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

  TCWebApi_commit("MeshRoleExchange_Entry")
  TCWebApi_commit("Mesh_dat")
  TCWebApi_save()

  if Request_Form("RebootReq") = "1" then
    TCWebApi_set("System_Entry","reboot_type","1")
    TCWebApi_commit("System_Entry")
  end if
end if

if Request_Form("defaultflag") = "1" then
  TCWebApi_Set("MeshRoleExchange_Entry", "ReserveConf", "ReserveConf")
  TCWebApi_save()
  TCWebApi_set("System_Entry","reboot_type","restoreflag")
  TCWebApi_commit("System_Entry")
end if
end if
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html lang="en" style="overflow: hidden;">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Operation Mode - Operation Mode</title>
  <link rel="stylesheet" href="/css/bootstrap.min.css">
  <link rel="stylesheet" href="/css/style.min.css">
  <link rel="stylesheet" href="/css/main.css">
  <script src="/scripts/lib/jquery.min.js"></script>
  <script src="/scripts/lib/bootstrap.min.js"></script>
  <script src="/scripts/lib/bootstrap.bundle.min.js"></script>
  <script src="/scripts/utils/util_skyw.js"></script>

<%if Request_Form("SaveAlter_Flag") = "1" then %>
  <script language=JavaScript type="text/javascript">
    var Tips = applyAlert({
      "content": "Settings applied successfully.",
      "buttons":{},
      "autoClose": 2
    });
  </script>
<% end if %>
</head>

<body>
  <div class="container-full container-resize-height">

    <form name="ConfigForm"
          action="/cgi-bin/true-page/other/OperationMode.asp"
          method="post">

      <input type="hidden" name="SaveFlag" value="0">
      <input type="hidden" name="deviceRoleChange_Flag" value="0">
      <input type="hidden" name="SaveAlter_Flag" value="0">
      <input type="hidden" name="OtherToAgent" value="0">
      <input type="hidden" name="VID" value="0">
      <input type="hidden" name="RebootReq" value="0">

      <div class="title-text">Operation Mode</div>

      <div class="title-description-text">
        This page is used to configure the operation mode of the device.
      </div>

<% if tcWebApi_get("vid_common", "skyvid","h") = "10" then %>

      <div class="row p-1">
        <div class="col-6">
          <div class="title-text-left">Operation Mode</div>
        </div>

        <div class="col-6">

          <input type="radio"
                 name="MapEnable"
                 id="MapEnableOn"
                 value="1"
                 onchange="MapEnableClick(1)">

          <label class="input-radio">Mesh</label>

          <input type="radio"
                 name="MapEnable"
                 id="MapEnableOff"
                 value="0"
                 onchange="MapEnableClick(0)">

          <label class="input-radio">AP</label>

        </div>
      </div>

<% else %>

      <div class="row p-1">
        <div class="col-6">
          <div class="title-text-left">EasyMesh</div>
        </div>

        <div class="col-6">

          <input type="radio"
                 id="MapEnableOn"
                 value="1"
                 disabled>

          <label class="input-radio">Enable</label>

          <input type="radio"
                 id="MapEnableOff"
                 value="0"
                 disabled>

          <label class="input-radio">Disable</label>

          <input type="hidden"
                 name="MapEnable"
                 value="<% tcWebApi_get("Mesh_dat", "MapEnable","s") %>">

        </div>
      </div>

<% end if %>

      <div class="row p-1"
           id="map-cfg-basic-devicerole-setting"
           style="display:none">

        <div class="col-6">
          <div class="title-text-left">Role:</div>
        </div>

        <div class="col-6">

          <input type="radio"
                 name="DeviceRole"
                 id="Role_Controller"
                 value="1">

          <label class="input-radio">Controller</label>

          <input type="radio"
                 name="DeviceRole"
                 id="Role_Agent"
                 value="2">

          <label class="input-radio">Agent</label>

          <input type="radio"
                 name="DeviceRole"
                 id="Role_Auto"
                 value="0">

          <label class="input-radio">Auto</label>

        </div>
      </div>
      <div class="title-text mt-3">
        Uplink Configuration
      </div>

      <div class="title-description-text">
        Configure the primary WAN uplink interface.
        LAN1-4 act as Mesh/Local LAN.
      </div>

      <div class="row p-1">

        <div class="col-6">
          <div class="title-text-left">
            Uplink Port:
          </div>
        </div>

        <div class="col-6">

          <input type="radio"
                 name="UplinkMode"
                 id="Uplink_25G"
                 value="25G">

          <label class="input-radio" for="Uplink_25G">
            2.5G LAN (EtherWAN)
          </label>

          <input type="radio"
                 name="UplinkMode"
                 id="Uplink_PON"
                 value="PON">

          <label class="input-radio" for="Uplink_PON">
            Fiber PON
          </label>

        </div>
      </div>

    </form>

    <div class="mt-3 mb-3 center">
      <button type="button"
              class="btn-dashboard"
              onclick="btnSave()">
        Apply Changes
      </button>
    </div>

  </div>
  <script>

    var initialUplink =
      "<% if tcWebApi_get("Wan_Common","TransMode","h") = "Ethernet" then asp_Write("25G") else asp_Write("PON") end if %>";

    var allowRoleChange = 1;

    $(document).ready(function()
    {
      InitRole();
      showRoleSel();
      initUplink();

<% if tcWebApi_get("XPON_Common","web_role_flag","h") = "0" then %>
      document.getElementById("Role_Controller").disabled = true;
      document.getElementById("Role_Agent").disabled = true;
      document.getElementById("Role_Auto").disabled = true;
<% end if %>

    });

    function initUplink()
    {
      if (initialUplink == "25G") {
        setCheck("Uplink_25G", 1);
        setCheck("Uplink_PON", 0);
      } else {
        setCheck("Uplink_25G", 0);
        setCheck("Uplink_PON", 1);
      }
    }

    function InitRole()
    {
      var MeshRole =
        "<% tcWebApi_get("MeshRoleExchange_Entry","MeshRole","s") %>";

      if(MeshRole == "1") {
        setCheck("Role_Controller", 1);
        setCheck("Role_Agent", 0);
        setCheck("Role_Auto", 0);

      } else if(MeshRole == "2") {
        setCheck("Role_Controller", 0);
        setCheck("Role_Agent", 1);
        setCheck("Role_Auto", 0);

      } else if(MeshRole == "0") {
        setCheck("Role_Controller", 0);
        setCheck("Role_Agent", 0);
        setCheck("Role_Auto", 1);
      }
    }

    function showRoleSel()
    {
      var mapEnable =
        "<% tcWebApi_get("Mesh_dat","MapEnable","s") %>";

      if(mapEnable == "1") {
        setCheck("MapEnableOn", 1);
        setCheck("MapEnableOff", 0);
        MapEnableClick(1);
      } else {
        setCheck("MapEnableOn", 0);
        setCheck("MapEnableOff", 1);
        MapEnableClick(0);
      }
    }

    function MapEnableClick(_val)
    {
      if(_val) {
        setDisplay(
          "map-cfg-basic-devicerole-setting",
          "1"
        );
      } else {
        setDisplay(
          "map-cfg-basic-devicerole-setting",
          "0"
        );
      }
    }

    function btnSave()
    {
      var selectedUplink =
        (document.getElementById("Uplink_25G").checked)
          ? "25G"
          : "PON";

      var uplinkChanged =
        (selectedUplink != initialUplink);

      if (uplinkChanged) {

        var warnAlert = simpleAlert({

          "closeAll": true,

          "content":
            "Uplink interface changed. " +
            "The device will save and restart to apply " +
            "hardware port remapping. Proceed?",

          "buttons": {

            "OK": function()
            {
              warnAlert.close();

              document.ConfigForm.RebootReq.value = "1";
              document.ConfigForm.SaveFlag.value = "1";
              document.ConfigForm.SaveAlter_Flag.value = "1";

              document.ConfigForm.submit();
            },

            "Cancel": function()
            {
              warnAlert.close();
            }

          }

        });

        return;
      }

      document.ConfigForm.SaveAlter_Flag.value = "1";
      document.ConfigForm.SaveFlag.value = "1";
      document.ConfigForm.submit();
    }

  </script>
</body>
</html>
