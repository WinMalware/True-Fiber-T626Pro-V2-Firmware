<%
If request_Form("Supplement_Flag_Value")="1" then
	tcWebApi_constSet("WebCurSet_Entry", "VoIPIdle", "1")
	if tcWebApi_get("VoIPBasic_Entry0", "Enable", "h") = "Yes"  then
		if tcWebApi_get("VoIPSysParam_Entry0", "SC_LINE_INFO_STATUS", "h") <> "Idle"  then
			tcWebApi_constSet("WebCurSet_Entry", "VoIPIdle", "0")
		end if
	end if
	
	if tcWebApi_get("WebCurSet_Entry", "VoIPIdle", "h") = "1"  then
		if tcWebApi_get("InfoVoIPH248_Entry0", "lineInfoStatus", "h") <> "N/A" then
			if tcWebApi_get("InfoVoIPH248_Entry0", "lineInfoStatus", "h") <> "Idle"  then
				tcWebApi_constSet("WebCurSet_Entry", "VoIPIdle", "0")
			end if
		end if
	end if
	if tcWebApi_get("WebCurSet_Entry", "VoIPIdle", "h") = "1"  then
		If request_Form("SIP_Flag_Value") = "1" then
			tcWebApi_set("VoIPCallCtrl_Entry0", "HotLineEnable", "hotline0Flag")
			tcWebApi_set("VoIPCallCtrl_Entry0", "HotLineNumber", "hotlinenum0")
			tcWebApi_set("VoIPCallCtrl_Entry0", "HotLineDelayTime", "hotlinetimeout0")
			tcWebApi_set("VoIPCallCtrl_Entry0", "ComingCallDisplayMode", "calleridmode0")
			tcWebApi_set("VoIPCallCtrl_Entry0", "SyncCallerTimeEnable", "synphonedate0")
			tcWebApi_set("VoIPCallCtrl_Entry0", "SIP3wayConf", "threepartyservice0Flag")
			tcWebApi_set("VoIPCallCtrl_Entry0", "SIPCallWaitingEnable", "callwait0Flag")
			tcWebApi_set("VoIPAdvanced_Common", "PolarityReversalMode", "DivRevPolarityType")
		else
			tcWebApi_set("VoIPCallCtrl_Entry0", "SyncCallerTimeEnable", "synphonedate0")
			tcWebApi_set("VoIPCallCtrl_Entry0", "ComingCallDisplayMode", "calleridmode0")
			tcWebApi_set("VoIPAdvanced_Entry0", "SubscribeType", "DivSubscribeType0")
			tcWebApi_set("VoIPCallCtrl_Entry0", "HotLineNumber", "hotlinenum0")
			tcWebApi_set("VoIPAdvanced_Common", "PolarityReversalMode", "DivRevPolarityType")
		end if
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
  <title>VoIP - Supplementary</title>
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
	var sm = "<%if tcWebApi_get("VoIPBasic_Common", "SIPProtocol", "h") = "SIP" then asp_Write("1") else asp_Write("0") end if %>";
	var Line1HotEnable = <%if tcWebApi_get("VoIPCallCtrl_Entry0", "HotLineEnable", "h") = "1" then asp_Write("1") else asp_Write("0") end if %>;
	function isInteger(value)
	{
		if (/^(\|)?\d+$/.test(value))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
    function limitNum(o)
	{
		if (o.value != "")
		{
			if (!isInteger(o.value))
			{
			  alert('"' + o.value + '"' + " can Only be numbers.");	
			  window.setTimeout( function(){ o.focus(); }, 0);
			}
		}
	}
	function clickHotline()
	{
		if( document.getElementById("hotline0").checked )
		{
			document.getElementById("hotlinetimeout0").disabled=false;
			document.getElementById("hotlinenum0").disabled=false;
		}
		else
		{
			document.getElementById("hotlinetimeout0").disabled=true;
			document.getElementById("hotlinenum0").disabled=true;
		}
	}
	function on_load()
	{
		if(sm != "1")
		{
			document.getElementById("IMS_Subscription").style.display ="";
			document.getElementById("SIP_HotEnable").style.display = "none";
			document.getElementById("SIP_HotDelay").style.display = "none";
			document.getElementById("SIP_3WayCalling").style.display = "none";
			document.getElementById("SIP_3CallWait").style.display = "none";
		}
		else
		{
			document.getElementById("IMS_Subscription").style.display = "none";
			document.getElementById("SIP_HotEnable").style.display = "";
			if(Line1HotEnable == "0")
			{
				document.getElementById("hotlinetimeout0").disabled=true;
				document.getElementById("hotlinenum0").disabled=true;
			}
			else
			{
				document.getElementById("hotlinetimeout0").disabled=false;
				document.getElementById("hotlinenum0").disabled=false;
			}
			document.getElementById("SIP_HotDelay").style.display = "";
			document.getElementById("SIP_3WayCalling").style.display = "";
			document.getElementById("SIP_3CallWait").style.display = "";
		}
	}
	function OnApplySupplememtary()
	{
		if(sm == "1")
		{
			if(document.getElementById("hotline0").checked)
			{
				hotline0Flag.value = 1;
			}
			if(document.getElementById("callwait0").checked)
			{
				callwait0Flag.value = 1;
			}
			if(document.getElementById("threepartyservice0").checked)
			{
				threepartyservice0Flag.value = "Yes";
			}
			document.VoipSupplementaryForm.SIP_Flag_Value.value = 1;
		}
		with(document.VoipSupplementaryForm)
		{
			document.VoipSupplementaryForm.SaveAlter_Flag.value = "1";
			document.VoipSupplementaryForm.Supplement_Flag_Value.value = 1;
			document.VoipSupplementaryForm.submit();
		}
	}
</script>
</head>
<body onload="on_load()">
	<div class="container-full container-resize-height">
		<div class="title-text">Supplementary</div>
		<div class="title-description-text">On this page, you can modify the broadband phone to supplement the business parameters.</div>
		<form name="VoipSupplementaryForm" action="/cgi-bin/true-page/vo-ip/Supplementary.asp" method="post">
			<input type="hidden" name="SaveAlter_Flag" value="0">
			<input type='hidden' value='0' id="Supplement_Flag_Value" name="Supplement_Flag_Value">
			<input type='hidden' value='0' id="SIP_Flag_Value" name="SIP_Flag_Value">
			<input type='hidden' value='0' id="hotline0Flag" name="hotline0Flag">
			<input type='hidden' value='0' id="callwait0Flag" name="callwait0Flag">
			<input type='hidden' value='No' id="threepartyservice0Flag" name="threepartyservice0Flag">
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Polarity Reversal:</div>
				</div>
				<div class="col-6">
					<select id="DivRevPolarityType" name="DivRevPolarityType" class="form-control input-select">
						<option value="0" <%if tcWebApi_get("VoIPAdvanced_Common", "PolarityReversalMode", "h") = "0" then asp_Write("selected") end if %>>OFF</option>
						<option value="1" <%if tcWebApi_get("VoIPAdvanced_Common", "PolarityReversalMode", "h") = "1" then asp_Write("selected") end if %>>Local On</option>
						<option value="2" <%if tcWebApi_get("VoIPAdvanced_Common", "PolarityReversalMode", "h") = "2" then asp_Write("selected") end if %>>Server Ctrl</option>
					</select>
				</div>
			</div>
			
			
			<div class="row p-1">
			  <div class="col-6">
				  <div class="title-text-left">Synchronize Phone Date Time:</div>
			  </div>
			  <div class="col-6">
				<select name='synphonedate0' id="syncCallTimeEnable" class="form-control input-select">
					<option value='0' <%if tcWebApi_get("VoIPCallCtrl_Entry0", "SyncCallerTimeEnable", "h") = "0" then  asp_Write("selected") end if %>>Forced without time</option>
					<option value='1' <%if tcWebApi_get("VoIPCallCtrl_Entry0", "SyncCallerTimeEnable", "h") = "1" then  asp_Write("selected") end if %>>Forced with time</option>
					<option value='2' <%if tcWebApi_get("VoIPCallCtrl_Entry0", "SyncCallerTimeEnable", "h") = "2" then  asp_Write("selected") end if %>>Auto</option>
				</select>
			  </div>
			</div>
			
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Display mode:</div>
				</div>
				<div class="col-6">
					<select name='calleridmode0' id="mymodeList" class="form-control input-select">
						<option value="0" <%if tcWebApi_get("VoIPCallCtrl_Entry0", "ComingCallDisplayMode", "h") = "0" then asp_Write("selected") end if %>>DTMF</option>
						<option value="1" <%if tcWebApi_get("VoIPCallCtrl_Entry0", "ComingCallDisplayMode", "h") = "1" then asp_Write("selected") end if %>>FSK</option>
					</select>
			  </div>
			</div>
			
			<div class="row p-1" id="IMS_Subscription">
				<div class="col-6">
					<div class="title-text-left">Subscription:</div>
				</div>
				<div class="col-6">
					<select name='DivSubscribeType0' id="mySubscriptionList" class="form-control input-select">
						<option value="0" <%if tcWebApi_get("VoIPAdvanced_Entry0", "SubscribeType", "h") = "0" then asp_Write("selected") end if %>>No subscription</option>
						<option value="1" <%if tcWebApi_get("VoIPAdvanced_Entry0", "SubscribeType", "h") = "1" then asp_Write("selected") end if %>>Subscription service</option>
						<option value="2" <%if tcWebApi_get("VoIPAdvanced_Entry0", "SubscribeType", "h") = "2" then asp_Write("selected") end if %>>Subscription registration</option>
						<option value="3" <%if tcWebApi_get("VoIPAdvanced_Entry0", "SubscribeType", "h") = "3" then asp_Write("selected") end if %>>Subscribe to all</option>
					</select>
				</div>
			</div>
			
			<div class="row p-1" id="SIP_HotEnable">
				<div class="col-6">
					<div class="title-text-left">Line 1 Enable Hotline:</div>
				</div>
				<div class="col-3">
					<input type='checkbox' size=10 name='hotline0' id='hotline0' onclick="clickHotline()" <%if tcWebApi_get("VoIPCallCtrl_Entry0", "HotLineEnable", "h") = "1" then asp_Write("checked") end if %> >
					<label class="input-radio">Enable</label>
				</div>
			</div>
			
			<div class="row p-1" id="SIP_HotDelay">
				<div class="col-6">
					<div class="title-text-left">Line1 Hotline Delay:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" size=20 maxlength=20 id='hotlinetimeout0' name='hotlinetimeout0' onchange='limitNum(this)' value='<%if tcWebApi_get("VoIPCallCtrl_Entry0", "HotLineDelayTime", "h") <> "N/A" then tcWebAPI_get("VoIPCallCtrl_Entry0", "HotLineDelayTime", "s") else asp_Write("") end if %>'>
				</div>			
			</div>
			
			<div class="row p-1" >
				<div class="col-6">
					<div class="title-text-left">Line1 Hotline Number:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" size=20 maxlength=20 id='hotlinenum0' name='hotlinenum0' value='<%if tcWebApi_get("VoIPCallCtrl_Entry0", "HotLineNumber", "h") <> "N/A" then tcWebAPI_get("VoIPCallCtrl_Entry0", "HotLineNumber", "s") else asp_Write("") end if %>'>
				</div>
			</div>
			
			<!----------
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Line1 3 Way Calling URI:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" size=20 maxlength=20 id='' name='' value=''>
				</div>
			</div>
			------------>
			
			<div class="row p-1" id="SIP_3WayCalling">
				<div class="col-6">
					<div class="title-text-left">Line1 3 Way Calling:</div>
				</div>
				<div class="col-6">
					<input type="checkbox" id="threepartyservice0" name="threepartyservice0" <%if tcWebApi_get("VoIPCallCtrl_Entry0", "SIP3wayConf", "h") = "Yes" then asp_Write("checked") end if %>>
					<label class="input-radio">Enable</label>
				</div>
			</div>
			
			<div class="row p-1" id="SIP_3CallWait">
				<div class="col-6">
					<div class="title-text-left">Line1 3 Call Waiting:</div>
				</div>
				<div class="col-6">
					<input type='checkbox' id='callwait0' name='callwait0' <%if tcWebApi_get("VoIPCallCtrl_Entry0", "SIPCallWaitingEnable", "h") = "1" then asp_Write("checked") end if %>>
					<label class="input-radio">Enable</label>
				</div>
			</div>
			
			
			<div class="mt-2 center">
				<button id="apply" name="apply" type="button" class="btn-dashboard" onclick="OnApplySupplememtary();">Apply</button>
			</div>
		</form>
	</div>
</body>
</html>