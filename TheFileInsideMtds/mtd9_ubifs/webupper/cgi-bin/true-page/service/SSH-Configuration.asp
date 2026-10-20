<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html lang="en" style="overflow: hidden;">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>SSH Configuration</title>
  <!-- style -->
  <link rel="stylesheet" href="/css/bootstrap.min.css">
  <link rel="stylesheet" href="/css/style.min.css">
  <link rel="stylesheet" href="/css/main.css">
  <!-- script -->
  <script src="/scripts/lib/jquery.min.js"></script>
  <script src="/scripts/lib/bootstrap.min.js"></script>
  <script src="/scripts/lib/bootstrap.bundle.min.js"></script>
  <script src="/scripts/utils/util_skyw.js"></script>
</head>

<body onload="LoadFrame()">
  <!-- content -->
  <div>
    <div class="container-full container-resize-height">
      <div class="title-text">SSH Configuration</div>
      <div class="title-description-text">
        This page is used to configure SSH service settings, listening port, interface binding, and IP access control (ACL).
      </div>

      <form name="SshForm" id="SshForm" action="/cgi-bin/ssh_ctl.cgi" method="post">
        <input type="hidden" name="action" value="apply">

        <div class="row p-1">
          <div class="col-6">
            <div class="title-text-left">SSH Service:</div>
          </div>
          <div class="col-6">
            <input type="radio" value="1" name="enabled" id="enabled_yes">
            <label class="input-radio" for="enabled_yes">Enable</label>
            <input type="radio" value="0" name="enabled" id="enabled_no">
            <label class="input-radio" for="enabled_no">Disable</label>
          </div>
        </div>

        <div class="row p-1">
          <div class="col-6">
            <div class="title-text-left">SSH Port:</div>
          </div>
          <div class="col-6">
            <input class="form-control input-textfield" name="port" id="ssh_port" value="22" type="text" maxlength="5">
          </div>
        </div>

        <div class="row p-1">
          <div class="col-6">
            <div class="title-text-left">Interface Access:</div>
          </div>
          <div class="col-6">
            <select class="form-control input-select" name="interface" id="ssh_interface">
              <option value="LAN">LAN Only</option>
              <option value="WAN">WAN Only</option>
            </select>
          </div>
        </div>

        <div class="mt-2 center">
          <button type="button" class="btn-dashboard" id="btnOK" onclick="btnSaveSsh()">Apply Changes</button>
          <button type="button" class="btn-dashboard" id="refresh" onclick="location.reload()">Apply Cancel</button>
        </div>
      </form>

      <hr>

      <div class="title-text">SSH IP Access Control (ACL)</div>
      <div class="title-description-text">
        Specify permitted client IP addresses or subnets. When rules are defined, only matching sources are allowed. If the table is empty, all sources on the selected interface are permitted.
      </div>

      <div class="row p-1">
        <div class="col-6">
          <div class="title-text-left">IP Address / Subnet:</div>
        </div>
        <div class="col-6">
          <input class="form-control input-textfield" id="newAclIp" placeholder="e.g. 192.168.1.100 or 192.168.1.0/24" type="text">
        </div>
      </div>

      <div class="mt-2 center">
        <button id="btnAdd" type="button" class="btn-dashboard" onclick="addClick()">Add</button>
      </div>

      <hr>

      <div class="card-table-content">
        <table style="width:100%" id="aclTable">
          <thead>
            <tr class="table-header center">
              <th style="width: 20%;" class="p-1">Current Filter Table</th>
              <th style="width: 80%;"></th>
            </tr>
            <tr class="table-header center">
              <td class="p-1">Select</td>
              <td class="p-1">Allowed IP Address / Subnet</td>
            </tr>
          </thead>
          <tbody id="aclTableBody">
          </tbody>
        </table>
      </div>

      <div class="mt-2 center">
        <button id="btnDelSelect" type="button" class="btn-dashboard" onclick="RemoveSelect()">Delete Selected</button>
        <button id="btnDelAll" type="button" class="btn-dashboard" onclick="RemoveAll()">Delete All</button>
      </div>

    </div>
  </div>
  <!-- content -->

  <script language="JavaScript" type="text/javascript">
    function LoadFrame() {
      loadData();
      var urlParams = new URLSearchParams(window.location.search);
      if (urlParams.get('saved') === '1') {
        if (typeof applyAlert === 'function') {
          applyAlert({
            "content": "Submit successful.",
            "buttons": {},
            "autoClose": 2
          });
        }
      }
    }

    var currentAcls = [];

    function loadData() {
      $.getJSON('/cgi-bin/ssh_ctl.cgi?action=get', function(data) {
        if (data.enabled === "1" || data.enabled === "Yes") {
          $('#enabled_yes').prop('checked', true);
        } else {
          $('#enabled_no').prop('checked', true);
        }
        $('#ssh_port').val(data.port || "22");
        if (data.interface === "WAN") {
          $('#ssh_interface').val("WAN");
        } else {
          $('#ssh_interface').val("LAN");
        }
        currentAcls = data.acls || [];
        renderAclTable(currentAcls);
      }).fail(function() {
        $('#enabled_yes').prop('checked', true);
        $('#ssh_port').val("22");
        $('#ssh_interface').val("LAN");
        renderAclTable([]);
      });
    }

    function renderAclTable(acls) {
      var tbody = $('#aclTableBody');
      tbody.empty();
      if (!acls || acls.length === 0) {
        tbody.append('<tr class="table-content-fist center" style="text-align: center; height: 30px;"><td colspan="2" style="color:#888; font-style:italic;">No ACL rules defined (Access open to all IPs on selected interface)</td></tr>');
        return;
      }
      for (var i = 0; i < acls.length; i++) {
        var rowCss = (i % 2 === 0) ? "table-content-fist" : "table-content-second";
        var row = '<tr class="' + rowCss + '" style="text-align: center; height: 30px;">' +
          '<td class="p-1"><input type="checkbox" name="acl_select" value="' + acls[i] + '"></td>' +
          '<td class="p-1">' + acls[i] + '</td>' +
          '</tr>';
        tbody.append(row);
      }
    }

    function btnSaveSsh() {
      var port = $('#ssh_port').val().trim();
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
      document.SshForm.submit();
    }

    function addClick() {
      var ip = $('#newAclIp').val().trim();
      var ipRegex = /^([0-9]{1,3}\.){3}[0-9]{1,3}(\/([0-9]|[1-2][0-9]|3[0-2]))?$/;
      if (!ip || !ipRegex.test(ip)) {
        if (typeof simpleAlert === 'function') {
          var alertTip = simpleAlert({
            "content": "Please enter a valid IP address or subnet (e.g. 192.168.1.100 or 192.168.1.0/24).",
            "buttons": { "OK": function() { alertTip.close(); } }
          });
        } else {
          alert("Please enter a valid IP address or subnet (e.g. 192.168.1.100 or 192.168.1.0/24).");
        }
        return;
      }
      if (typeof showLoading === 'function') {
        showLoading();
      }
      $.post('/cgi-bin/ssh_ctl.cgi', { action: 'add_acl', ip: ip }, function() {
        if (typeof hiddenLoading === 'function') {
          hiddenLoading();
        }
        $('#newAclIp').val('');
        loadData();
      });
    }

    function RemoveSelect() {
      var selected = [];
      $('input[name="acl_select"]:checked').each(function() {
        selected.push($(this).val());
      });
      if (selected.length === 0) {
        if (typeof simpleAlert === 'function') {
          var alertTip = simpleAlert({
            "content": "Please select at least one item.",
            "buttons": { "OK": function() { alertTip.close(); } }
          });
        } else {
          alert("Please select at least one item.");
        }
        return;
      }
      if (typeof simpleAlert === 'function') {
        var deleteTips = simpleAlert({
          "content": "Are you sure to delete selected item(s)?",
          "buttons": {
            "OK": function() {
              deleteTips.close();
              if (typeof showLoading === 'function') {
                showLoading();
              }
              $.post('/cgi-bin/ssh_ctl.cgi', { action: 'del_selected', del_ips: selected.join(',') }, function() {
                if (typeof hiddenLoading === 'function') {
                  hiddenLoading();
                }
                loadData();
              });
            },
            "Cancel": function() {
              deleteTips.close();
            }
          }
        });
      } else {
        if (confirm("Are you sure to delete selected item(s)?")) {
          $.post('/cgi-bin/ssh_ctl.cgi', { action: 'del_selected', del_ips: selected.join(',') }, function() {
            loadData();
          });
        }
      }
    }

    function RemoveAll() {
      if (currentAcls.length === 0) {
        if (typeof simpleAlert === 'function') {
          var alertTip = simpleAlert({
            "content": "The table is already empty.",
            "buttons": { "OK": function() { alertTip.close(); } }
          });
        } else {
          alert("The table is already empty.");
        }
        return;
      }
      if (typeof simpleAlert === 'function') {
        var deleteTips = simpleAlert({
          "content": "Are you sure to delete all items? Access will be open to all IPs on selected interface.",
          "buttons": {
            "OK": function() {
              deleteTips.close();
              if (typeof showLoading === 'function') {
                showLoading();
              }
              $.post('/cgi-bin/ssh_ctl.cgi', { action: 'del_all' }, function() {
                if (typeof hiddenLoading === 'function') {
                  hiddenLoading();
                }
                loadData();
              });
            },
            "Cancel": function() {
              deleteTips.close();
            }
          }
        });
      } else {
        if (confirm("Are you sure to delete all items? Access will be open to all IPs on selected interface.")) {
          $.post('/cgi-bin/ssh_ctl.cgi', { action: 'del_all' }, function() {
            loadData();
          });
        }
      }
    }
  </script>
</body>

</html>
