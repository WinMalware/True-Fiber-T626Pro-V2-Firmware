<%
If request_Form("VoIP_Fax_flag")="1" then
	tcWebApi_constSet("WebCurSet_Entry", "VoIPIdle", "1")
	if tcWebApi_get("VoIPBasic_Entry0", "Enable", "h") = "Yes"  then
		if tcWebApi_get("VoIPSysParam_Entry0", "SC_LINE_INFO_STATUS", "h") <> "N/A"  then
			if tcWebApi_get("VoIPSysParam_Entry0", "SC_LINE_INFO_STATUS", "h") <> "Idle"  then
				tcWebApi_constSet("WebCurSet_Entry", "VoIPIdle", "0")
			end if
		end if
	end if
	
	if tcWebApi_get("WebCurSet_Entry", "VoIPIdle", "h") = "1"  then
		tcWebApi_set("VoIPAdvanced_Common", "RegistrationExpire", "regExpTmr")
		tcWebApi_set("VoIPAdvanced_Common", "MaxStartDelay", "maxStartDelay")
		tcWebApi_set("VoIPAdvanced_Common", "RegisterRetryInterval", "regRetryInt")
	
	tcWebApi_set("VoIPAdvanced_Common", "FaxCtrlMode", "faxctrlmode")
	tcWebApi_set("VoIPMedia_Common", "FaxCodec", "t38EnableFlag")
	tcWebApi_commit("VoIPBasic_Common")
	tcWebApi_save()
	end if
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html lang="en" style="overflow: hidden;">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>VoIP - Fax Setup</title>
  <!-- style -->
  <link rel="stylesheet" href="/css/bootstrap.min.css">
  <link rel="stylesheet" href="/css/style.min.css">
  <!-- style -->

  <!-- script -->
  <script src="/scripts/lib/jquery.min.js"></script>
  <script src="/scripts/lib/bootstrap.min.js"></script>
  <script src="/scripts/lib/bootstrap.bundle.min.js"></script>
  <!-- script -->

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

  <script language=JavaScript type=text/javascript>
    function on_load()
	{
		//TODO
	}
	
	function OnApplyFax()
	{
		var t38Flag=document.getElementById("t38Enable");
		with(document.VoipFaxSetForm)
		{
			if(t38Flag.checked)
			{
				t38EnableFlag.value=1;
			}
			document.VoipFaxSetForm.SaveAlter_Flag.value = "1";
			VoIP_Fax_flag.value=1;
			submit();
			//showLoading();
		}
	}
  </script>
</head>
<body onload="on_load()">
	<div class="container-full container-resize-height">
		<div class="title-text">Fax Setup</div>
		<div class="title-description-text">On this page, you can modify the broadband phone fax parameters.</div>
		<form name="VoipFaxSetForm" action="/cgi-bin/true-page/vo-ip/Fax-Setup.asp" method="post">
			<input type='hidden' value='0' id="t38EnableFlag" name="t38EnableFlag">
			<input type='hidden' value='0' id="VoIP_Fax_flag" name="VoIP_Fax_flag">
			<input type="hidden" name="SaveAlter_Flag" value="0">
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">T.38 Fax Enable:</div>
				</div>
				<div class="col-6">
					<input type='checkbox' name='t38Enable' id='t38Enable' value='1'<%if tcWebApi_get("VoIPMedia_Common", "FaxCodec", "h") = "1" then asp_Write("checked") end if %>>
					<label class="input-radio">Enable</label>
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">T.30 Negotiation:</div>
				</div>
				<div class="col-6">
					<select id="faxctrlmode" class="form-control input-select" name="faxctrlmode">
						<option value="other" <%if tcWebApi_get("VoIPAdvanced_Common", "FaxCtrlMode", "h") = "other" then asp_Write("selected") end if %>>Auto Negotiation</option>
						<option value="all" <%if tcWebApi_get("VoIPAdvanced_Common", "FaxCtrlMode", "h") = "all" then asp_Write("selected") end if %>>All Control</option>
					</select>
				</div>
			</div>
			
			
			<div class="mt-2 center">
				<button id="apply" name="apply" type="button" class="btn-dashboard" onclick="OnApplyFax();">Apply</button>
			</div>
		</form>
	</div>
</body>
</html>