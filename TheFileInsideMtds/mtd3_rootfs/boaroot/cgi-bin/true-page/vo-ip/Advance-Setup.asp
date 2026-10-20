<%
If request_Form("VoIP_Advance_Submit_flag")="1" then
	tcWebApi_constSet("WebCurSet_Entry", "VoIPIdle", "1")
	if tcWebApi_get("VoIPBasic_Entry0", "Enable", "h") = "Yes"  then
		if tcWebApi_get("VoIPSysParam_Entry0", "SC_LINE_INFO_STATUS", "h") <> "Idle"  then
			tcWebApi_constSet("WebCurSet_Entry", "VoIPIdle", "0")
		end if
	end if
	
	if tcWebApi_get("WebCurSet_Entry", "VoIPIdle", "h") = "1"  then
		tcWebApi_set("VoIPAdvanced_Common", "DTMFTransportMode", "dtmfRelay")
		tcWebApi_set("VoIPCodecs_PVC0", "SIPPacketizationTime", "voicePtime0")
		tcWebApi_set("VoIPBasic_Common", "LocalSIPPort", "lclSIPPort")
		tcWebApi_set("VoIPAdvanced_Common", "RegistrationExpire", "regExpTmr")
		tcWebApi_set("VoIPAdvanced_Common", "RegisterRetryInterval", "regRetryInt")
		tcWebApi_set("VoIPBasic_Common", "PRACKEnable", "PrackRadio_Enable_flag")
		tcWebApi_set("VoIPBasic_Common", "SIPDSCPMark", "dscpmark")
		tcWebApi_set("VoIPBasic_Common", "RTPDSCPMark", "mymgtos")
		tcWebApi_set("VoIPAdvanced_Common", "SC_SYS_VOICE_JB_LEN", "JBMaxLen")
		tcWebApi_set("VoIPMedia_Common", "EchoCancellationEnable", "echoCancel_Enable_flag")
		tcWebApi_set("VoIPAdvanced_Entry0", "VoiceVolumeSpeak", "ingressGain0")
		tcWebApi_set("VoIPAdvanced_Entry0", "VoiceVolumeListen", "egressGain0")
		tcWebApi_set("VoIPCodecs_PVC0_Entry0", "priority", "codecList0")
		tcWebApi_set("VoIPCodecs_PVC1_Entry0", "priority", "codecList1")
		tcWebApi_set("VoIPCodecs_PVC0_Entry1", "priority", "codecList2")
		tcWebApi_set("VoIPCodecs_PVC1_Entry1", "priority", "codecList3")
		tcWebApi_set("VoIPCodecs_PVC0_Entry2", "priority", "codecList4")
		tcWebApi_set("VoIPCodecs_PVC1_Entry2", "priority", "codecList5")
		tcWebApi_set("VoIPCodecs_PVC0_Entry3", "priority", "codecList6")
		tcWebApi_set("VoIPCodecs_PVC1_Entry3", "priority", "codecList7")
		
		tcWebApi_set("VoIPBasic_Common", "SC_ACCT_SIP_SESSION_FLAG", "sessiontimerEnableFlag")
		if request_Form("sessiontimerEnableFlag") = "1" then
			tcWebApi_set("VoIPBasic_Common", "SC_ACCT_SIP_SESSION_TIMER", "sessionTimer")
		end if
		
		tcWebApi_commit("VoIPBasic_Common")
		tcWebApi_save()
	end If
end if
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html lang="en" style="overflow: hidden;">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>VoIP - Advance Setup</title>
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
	function isValidPort(port)
	{
		if (!isInteger(port) || port < 0 || port > 65535)
		{
			return false;
		}
		
		return true;
	}
	function isInteger(value)
	{
		if (/^(-|\|)?\d+$/.test(value))
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
	function checkPort(o)
	{
	  if (o.value != "")
	  {
		if (!isInteger(o.value) || !isValidPort(o.value))
		{
		  alert('"' + o.value + '"' + " is invalid port.");	
		  window.setTimeout( function(){ o.focus(); }, 0);
		}
	  }
	}
	function sessionClick(cb)
	{
		if(cb.checked == true )
		{
			document.getElementById("seessionExpireTime").style.display = "";

		}
		else
		{
			document.getElementById("seessionExpireTime").style.display = "none";
		}
	}
    function OnApplyAdvance()
	{
		with(document.VoipAdvanceSetForm)
		{
			var temp = parseInt(lclSIPPort.value);
			if (temp < 1025 || temp > 65535)
			{
			  alert("SIP Local Port is error,please check");
			  return;
			}

			var temp = parseInt(regExpTmr.value);
			if (temp < 20 || temp > 65535)
			{
			  alert("Register Expire Time is error,please check");
			  return;
			}

			var temp = parseInt(regRetryInt.value);	
			if (temp < 1 || temp > 3600)
			{
			  alert("Register Fail Retry Time is error,please check");
			  return;
			}
			var temp1 = parseInt(sessionTimer.value);	
			if (temp1 < 120 || temp1 > 3600)
			{
			  alert("session Expire Time is error,please check");
			  return;
			}
			var temp = parseInt (dscpmark.value);
			if (temp < 0 || temp > 63)
			{
			  alert ("SIP DSCP MARK is error ! please check");
			  return;
			}
			var temp = parseInt (mymgtos.value);
			if (temp < 0 || temp > 63)
			{
			  alert ("RTP DSCP MARK is error ! please check");
			  return;
			}
			var temp = parseInt(JBMaxLen.value);	
			if (temp < 1 || temp > 1000)
			{
			  alert("Jittbuffter Maximum is error ! please check");
			  return;
			}
			var temp = parseInt(egressGain0.value);	
			if (temp < -12 || temp > 12)
			{
			  alert("Line1 DSP Rx Gain is error ! please check !");
			  return;
			} 
			var temp = parseInt(ingressGain0.value);	
			if (temp < -12 || temp > 12)
			{
			  alert("Line1 DSP Tx Gain is error ! please check!");
			  return;
			}
			
			
			if (document.getElementById("PrackRadio").checked)
			{
			  PrackRadio_Enable_flag.value = "Yes";
			}
			if (document.getElementById("EchoCancellRadio").checked)
			{
			  echoCancel_Enable_flag.value = "Yes";
			}
			if (sessiontimerEnable.checked)
			{
				sessiontimerEnableFlag.value = "1";
			}
			//code check
			var codecOld = "";
			var codecNew = "";
			var k = 0;
			var m = 0;
			var mm = 0;
			var zz = 0;
			for (k = 0; k < 8; k+=2) 
			{
				codecOld = codecOld + "," + codecNew;
				if(k==0){
				  codecNew = document.getElementById("codecList0").value;
				}else if(k==1){
				  codecNew = document.getElementById("codecList1").value;
				}else if(k==2){
				  codecNew = document.getElementById("codecList2").value;
				}else if(k==3){
				  codecNew = document.getElementById("codecList3").value;
				}else if(k==4){
				  codecNew = document.getElementById("codecList4").value;
				}else if(k==5){
				  codecNew = document.getElementById("codecList5").value;
				}else if(k==6){
				  codecNew = document.getElementById("codecList6").value;
				}else if(k==7){
				  codecNew = document.getElementById("codecList7").value;
				}
				codecList = codecOld.split(",");
				for (var j = 0;j < codecList.length;j++)
				{
				  if (codecNew != 0 && codecNew == codecList[j])
				  {
					alert("Codec priority setting is repeated, please reset it!");
					return;
				  }
				}
				if(codecNew == 0)
				{
					zz++;
				}
			}
			if(zz == 4)
			{
				alert("Do not disable all voice code, please select one or more.");
				return;
			}
		
			
			//submit
			document.VoipAdvanceSetForm.SaveAlter_Flag.value = "1";
			VoIP_Advance_Submit_flag.value=1;
			VoipAdvanceSetForm.submit();
		}
		
	}
  </script>
</head>
<body onload="on_load()">
	<div class="container-full container-resize-height">
		<div class="title-text">Advance Setup</div>
		<div class="title-description-text">On this page, you can modify the advanced parameters of broadband telephone.</div>
		<form id="VoipAdvanceSetForm" name="VoipAdvanceSetForm" action="/cgi-bin/true-page/vo-ip/Advance-Setup.asp" method="post">
			<div style="display:none;">
				<input type='hidden' name="VoIP_Advance_Submit_flag"  value="0">
				<input type="hidden" name="SaveAlter_Flag" value="0">
				<input type='hidden' name="PrackRadio_Enable_flag"  value="No">
				<input type='hidden' name="echoCancel_Enable_flag"  value="No">
				<input type='hidden' value='0' id="sessiontimerEnableFlag" name="sessiontimerEnableFlag">
			</div>
	
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Second Dailing Mode:</div>
				</div>
				<div class="col-6">
					<select name="dtmfRelay" id="DTMFTrans" class="form-control input-select">
						<option value="SIPInfo" <%if tcWebApi_get("VoIPAdvanced_Common", "DTMFTransportMode", "h") = "SIPInfo" then asp_Write("selected") end if %>>SIPInfo</option>
						<option value="RFC2833" <%if tcWebApi_get("VoIPAdvanced_Common", "DTMFTransportMode", "h") = "RFC2833" then asp_Write("selected") end if %>>RPC2833</option>
						<option value="InBand" <%if tcWebApi_get("VoIPAdvanced_Common", "DTMFTransportMode", "h") = "InBand" then asp_Write("selected") end if %>>InBand</option>
					</select>
			  </div>
			</div>
			
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">SIP Local Port:</div>
				</div>
				<div class="col-3">
					<input type='text' class="form-control input-textfield" name='lclSIPPort' onblur="checkPort(this)" value="<% tcWebApi_get("VoIPBasic_Common","LocalSIPPort","s")%>">
				</div>
				<div class="col-3 left">
				  <label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">[1025-65535]</label>
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Register Expire Time:</div>
				</div>
				<div class="col-3">
                    <input type='text'  class="form-control input-textfield" name='regExpTmr' onblur="limitNum(this)" value="<%if tcWebApi_get("VoIPAdvanced_Common", "RegistrationExpire", "h") <> "N/A" then tcWebAPI_get("VoIPAdvanced_Common", "RegistrationExpire", "s") else asp_Write("") end if %>">
				</div>
				<div class="col-3 left">
				  <label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">(20-65535)s</label>
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Register Fail Retry Time:</div>
				</div>
				<div class="col-3">
					<input type='text' class="form-control input-textfield" name='regRetryInt' onblur="limitNum(this)" value="<%if tcWebApi_get("VoIPAdvanced_Common", "RegisterRetryInterval", "h") <> "N/A" then tcWebAPI_get("VoIPAdvanced_Common", "RegisterRetryInterval", "s") else asp_Write("") end if %>">
				</div>
				<div class="col-3 left">
				  <label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">(1-3600)s</label>
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Enable Session:</div>
				</div>
				<div class="col-6">
					<input type='checkbox' name='sessiontimerEnable' onClick='sessionClick(this)' ID="Checkbox11" value='0' <%if tcWebApi_get("VoIPBasic_Common", "SC_ACCT_SIP_SESSION_FLAG", "h") = "1" then asp_Write("checked") end if %>>
					<label class="input-radio">Enable</label>
				</div>
			</div>
			
			<div class="row p-1" id="seessionExpireTime">
				<div class="col-6">
					<div class="title-text-left">session Expire Time:</div>
				</div>
				<div class="col-3">
					<input type='text' class="form-control input-textfield" name='sessionTimer' onblur="limitNum(this)" value="<%if tcWebApi_get("VoIPBasic_Common", "SC_ACCT_SIP_SESSION_TIMER", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "SC_ACCT_SIP_SESSION_TIMER", "s") else asp_Write("") end if %>">
				</div>
				<div class="col-3 left">
					<label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">(120~3600)s</label>
				</div>
			</div>

			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Enable PRACK:</div>
				</div>
				<div class="col-6">
					<input type='checkbox' name='PrackEnable' id="PrackRadio" value='YES' <%if tcWebApi_get("VoIPBasic_Common", "PRACKEnable", "h") = "Yes" then asp_Write("checked") end if %>>
					<label class="input-radio">Enable</label>
				</div>
			</div>
			
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">SIP DSCP MARK:</div>
				</div>
				<div class="col-3">
					<input type='text' class="form-control input-textfield"  id='dscpmark' name='dscpmark' onchange='limitNum(this)' value="<%if tcWebApi_get("VoIPBasic_Common", "SIPDSCPMark", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "SIPDSCPMark", "s") else asp_Write("") end if %>">
				</div>
				<div class="col-3 left">
				  <label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">(0~63)</label>
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">RTP DSCP MARK:</div>
				</div>
				<div class="col-3">
					<input type="text" name="mymgtos" class="form-control input-textfield"  id="in_h_tos_val" onchange="limitNum(this)" value="<%if tcWebApi_get("VoIPBasic_Common", "RTPDSCPMark", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "RTPDSCPMark", "s") else asp_Write("") end if %>">
				</div>
				<div class="col-3 left">
					<label class="input-radio" style="line-height:30px; margin-bottom: 0px;">(0~63)</label>
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Jittbuffter Maximum:</div>
				</div>
				<div class="col-3">
					<input type='text' class="form-control input-textfield" name='JBMaxLen' onblur="limitNum(this)" value="<%if tcWebApi_get("VoIPAdvanced_Common", "SC_SYS_VOICE_JB_TYPE", "h") <> "2" then if tcWebApi_get("VoIPAdvanced_Common", "SC_SYS_VOICE_JB_LEN", "h") <> "N/A" then tcWebAPI_get("VoIPAdvanced_Common", "SC_SYS_VOICE_JB_LEN", "s") else asp_Write("200") end if else asp_Write("200") end if %>">
				</div>
				<div class="col-1 left">
				  <label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">(1~1000)ms</label>
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Line1 DSP Rx Gain:</div>
				</div>
				<div class="col-3">
					<input class="form-control input-textfield" type='text' name='egressGain0' onblur='limitNum(this)' value='<%if tcWebApi_get("VoIPAdvanced_Entry0", "VoiceVolumeListen", "h") <> "N/A" then tcWebAPI_get("VoIPAdvanced_Entry0", "VoiceVolumeListen", "s") else asp_Write("") end if %>'>
				</div>
				<div class="col-1 left">
				  <label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">(-12~12)dB</label>
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Line1 DSP Tx Gain:</div>
				</div>
				<div class="col-3">
					<input class="form-control input-textfield" type='text' name='ingressGain0' onblur='limitNum(this)' value='<%if tcWebApi_get("VoIPAdvanced_Entry0", "VoiceVolumeSpeak", "h") <> "N/A" then tcWebAPI_get("VoIPAdvanced_Entry0", "VoiceVolumeSpeak", "s") else asp_Write("") end if %>'>
				</div>
				<div class="col-1 left">
					<label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">(-12~12)dB</label>
				  </div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Echo Cancellation:</div>
				</div>
				<div class="col-6">
					<input type='checkbox' name='echoCancelEnable' id="EchoCancellRadio" value='YES' <%if tcWebApi_get("VoIPMedia_Common", "EchoCancellationEnable", "h") = "Yes" then asp_Write("checked") end if %>>
					<label class="input-radio">Enable</label>
				</div>
			</div>
			
			<div class="card-table">
				<div class="table-header">Line1 Codec Priority</div>
				<div id="perLineTablePlaceholder1">
				</div>
			</div>
			
			
			<div class="mt-2 center">
				<button id="apply" name="apply" type="button" class="btn-dashboard" onclick="OnApplyAdvance();">Apply</button>
			</div>
		</form>
	</div>
<script>

function generatePerLineTable()
{
	if(document.body.innerHTML)
	{
		var tableHtmlOutput="<table id=\"perLineTabel\" style=\"width:100%;cellSpacing=0;border=0;\"><tbody><tr class=\"table-header center\"><td style=\"width: 50;\" class=\"p-1\" align=center >Codec</td><td style=\"width: 50%;\" align=center >Priority</td></tr>";
		var lineNumber = parseInt('<% tcwebApi_get("VoIPBasic_Common","VoIPLineNumber","s") %>');
		//thead----line head
		tableHtmlOutput += "";
		if(lineNumber > 1)
		{
			console.log("error!");
		}
		
		// Codec rows --722
		tableHtmlOutput += "<tr class=\"table-content-fist\" ><td class=\"p-1\" align=center>G.722<\/td>"
<% if tcwebApi_get("WebCustom_Entry","isVoipPortReverseSupported","h") <> "Yes" then %>
		var selectOptions0 = Array();
		selectOptions0[0] = "<option value=" + 0 + " >" + "0";
		selectOptions0[1] = "<option value=" + 1 + " >" + "1";
		selectOptions0[2] = "<option value=" + 2 + " >" + "2";
		selectOptions0[3] = "<option value=" + 3 + " >" + "3";
		selectOptions0[4] = "<option value=" + 4 + " >" + "4";
		selectOptions0[5] = "<option value=" + 5 + " >" + "5";
		selectOptions0[6] = "<option value=" + 6 + " >" + "6";
		selectOptions0[7] = "<option value=" + 7 + " >" + "7";
		tableHtmlOutput += "<td align=center  width=180><select name='codecList0' id='codecList0'>" + selectOptions0.join("") + "<\/select></td>";
<% end if %>
<% if tcwebApi_get("VoIPBasic_Common","VoIPLine2Enable","h") = "Yes" then %>
		var selectOptions1 = Array();
		selectOptions1[0] = "<option value=" + 0 + " >" + "0";
		selectOptions1[1] = "<option value=" + 1 + " >" + "1";
		selectOptions1[2] = "<option value=" + 2 + " >" + "2";
		selectOptions1[3] = "<option value=" + 3 + " >" + "3";
		selectOptions1[4] = "<option value=" + 4 + " >" + "4";
		selectOptions1[5] = "<option value=" + 5 + " >" + "5";
		selectOptions1[6] = "<option value=" + 6 + " >" + "6";
		selectOptions1[7] = "<option value=" + 7 + " >" + "7";
		tableHtmlOutput += "<td align=center  width=180><select name='codecList1'>" + selectOptions1.join("") + "<\/select></td>"; 
<% end if %>
<% if tcwebApi_get("WebCustom_Entry","isVoipPortReverseSupported","h") = "Yes" then %>
		var selectOptions0 = Array();
		selectOptions0[0] = "<option value=" + 0 + " >" + "0";
		selectOptions0[1] = "<option value=" + 1 + " >" + "1";
		selectOptions0[2] = "<option value=" + 2 + " >" + "2";
		selectOptions0[3] = "<option value=" + 3 + " >" + "3";
		selectOptions0[4] = "<option value=" + 4 + " >" + "4";
		selectOptions0[5] = "<option value=" + 5 + " >" + "5";
		selectOptions0[6] = "<option value=" + 6 + " >" + "6";
		selectOptions0[7] = "<option value=" + 7 + " >" + "7";
		tableHtmlOutput += "<td align=center  width=180><select name='codecList0' id='codecList0'>" + selectOptions0.join("") + "<\/select></td>";
<% end if %>
		tableHtmlOutput += "</tr>";
		
	
	// Codec rows --711ALaw
		tableHtmlOutput += "<tr class=\"table-content-second\"><td class=\"p-1\" align=center>G.711ALaw<\/td>"
<% if tcwebApi_get("WebCustom_Entry","isVoipPortReverseSupported","h") <> "Yes" then %>
		var selectOptions2 = Array();
		selectOptions2[0] = "<option value=" + 0 + " >" + "0";
		selectOptions2[1] = "<option value=" + 1 + " >" + "1";
		selectOptions2[2] = "<option value=" + 2 + " >" + "2";
		selectOptions2[3] = "<option value=" + 3 + " >" + "3";
		selectOptions2[4] = "<option value=" + 4 + " >" + "4";
		selectOptions2[5] = "<option value=" + 5 + " >" + "5";
		selectOptions2[6] = "<option value=" + 6 + " >" + "6";
		selectOptions2[7] = "<option value=" + 7 + " >" + "7";
		tableHtmlOutput += "<td align=center  ><select name='codecList2' id='codecList2'>" + selectOptions2.join("") + "<\/select></td>";
<% end if %>
<% if tcwebApi_get("VoIPBasic_Common","VoIPLine2Enable","h") = "Yes" then %>
		var selectOptions3 = Array();
		selectOptions3[0] = "<option value=" + 0 + " >" + "0";
		selectOptions3[1] = "<option value=" + 1 + " >" + "1";
		selectOptions3[2] = "<option value=" + 2 + " >" + "2";
		selectOptions3[3] = "<option value=" + 3 + " >" + "3";
		selectOptions3[4] = "<option value=" + 4 + " >" + "4";
		selectOptions3[5] = "<option value=" + 5 + " >" + "5";
		selectOptions3[6] = "<option value=" + 6 + " >" + "6";
		selectOptions3[7] = "<option value=" + 7 + " >" + "7";
		tableHtmlOutput += "<td align=center  ><select name='codecList3'>" + selectOptions3.join("") + "<\/select></td>";  
<% end if %>
<% if tcwebApi_get("WebCustom_Entry","isVoipPortReverseSupported","h") = "Yes" then %>
		var selectOptions2 = Array();
		selectOptions2[0] = "<option value=" + 0 + " >" + "0";
		selectOptions2[1] = "<option value=" + 1 + " >" + "1";
		selectOptions2[2] = "<option value=" + 2 + " >" + "2";
		selectOptions2[3] = "<option value=" + 3 + " >" + "3";
		selectOptions2[4] = "<option value=" + 4 + " >" + "4";
		selectOptions2[5] = "<option value=" + 5 + " >" + "5";
		selectOptions2[6] = "<option value=" + 6 + " >" + "6";
		selectOptions2[7] = "<option value=" + 7 + " >" + "7";
		tableHtmlOutput += "<td align=center  ><select name='codecList2' id='codecList2'>" + selectOptions2.join("") + "<\/select></td>";
<% end if %>
		tableHtmlOutput += "</tr>";

		// Codec rows --711ULaw
		tableHtmlOutput += "<tr class=\"table-content-fist\"><td class=\"p-1\" align=center>G.711ULaw<\/td>"
<% if tcwebApi_get("WebCustom_Entry","isVoipPortReverseSupported","h") <> "Yes" then %>
		var selectOptions4 = Array();
		selectOptions4[0] = "<option value=" + 0 + " >" + "0";
		selectOptions4[1] = "<option value=" + 1 + " >" + "1";
		selectOptions4[2] = "<option value=" + 2 + " >" + "2";
		selectOptions4[3] = "<option value=" + 3 + " >" + "3";
		selectOptions4[4] = "<option value=" + 4 + " >" + "4";
		selectOptions4[5] = "<option value=" + 5 + " >" + "5";
		selectOptions4[6] = "<option value=" + 6 + " >" + "6";
		selectOptions4[7] = "<option value=" + 7 + " >" + "7";
		tableHtmlOutput += "<td align=center  ><select name='codecList4' id='codecList4'>" + selectOptions4.join("") + "<\/select></td>";
<% end if %>
<% if tcwebApi_get("VoIPBasic_Common","VoIPLine2Enable","h") = "Yes" then %>
		var selectOptions5 = Array();
		selectOptions5[0] = "<option value=" + 0 + " >" + "0";
		selectOptions5[1] = "<option value=" + 1 + " >" + "1";
		selectOptions5[2] = "<option value=" + 2 + " >" + "2";
		selectOptions5[3] = "<option value=" + 3 + " >" + "3";
		selectOptions5[4] = "<option value=" + 4 + " >" + "4";
		selectOptions5[5] = "<option value=" + 5 + " >" + "5";
		selectOptions5[6] = "<option value=" + 6 + " >" + "6";
		selectOptions5[7] = "<option value=" + 7 + " >" + "7";
		tableHtmlOutput += "<td align=center  ><select name='codecList5'>" + selectOptions5.join("") + "<\/select></td>";
<% end if %> 
<% if tcwebApi_get("WebCustom_Entry","isVoipPortReverseSupported","h") = "Yes" then %>
		var selectOptions4 = Array();
		selectOptions4[0] = "<option value=" + 0 + " >" + "0";
		selectOptions4[1] = "<option value=" + 1 + " >" + "1";
		selectOptions4[2] = "<option value=" + 2 + " >" + "2";
		selectOptions4[3] = "<option value=" + 3 + " >" + "3";
		selectOptions4[4] = "<option value=" + 4 + " >" + "4";
		selectOptions4[5] = "<option value=" + 5 + " >" + "5";
		selectOptions4[6] = "<option value=" + 6 + " >" + "6";
		selectOptions4[7] = "<option value=" + 7 + " >" + "7";
		tableHtmlOutput += "<td align=center  ><select name='codecList4' id='codecList4'>" + selectOptions4.join("") + "<\/select></td>";
<% end if %>
		tableHtmlOutput += "</tr>"; 
	// Codec rows --729
tableHtmlOutput += "<tr class=\"table-content-second\"><td class=\"p-1\" align=center>G.729<\/td>"
<% if tcwebApi_get("WebCustom_Entry","isVoipPortReverseSupported","h") <> "Yes" then %>
		var selectOptions6 = Array();
		selectOptions6[0] = "<option value=" + 0 + " >" + "0";
		selectOptions6[1] = "<option value=" + 1 + " >" + "1";
		selectOptions6[2] = "<option value=" + 2 + " >" + "2";
		selectOptions6[3] = "<option value=" + 3 + " >" + "3";
		selectOptions6[4] = "<option value=" + 4 + " >" + "4";
		selectOptions6[5] = "<option value=" + 5 + " >" + "5";
		selectOptions6[6] = "<option value=" + 6 + " >" + "6";
		selectOptions6[7] = "<option value=" + 7 + " >" + "7";
		tableHtmlOutput += "<td align=center  ><select name='codecList6' id='codecList6'>" + selectOptions6.join("") + "<\/select></td>";
<% end if %>
<% if tcwebApi_get("VoIPBasic_Common","VoIPLine2Enable","h") = "Yes" then %>
		var selectOptions7 = Array();
		selectOptions7[0] = "<option value=" + 0 + " >" + "0";
		selectOptions7[1] = "<option value=" + 1 + " >" + "1";
		selectOptions7[2] = "<option value=" + 2 + " >" + "2";
		selectOptions7[3] = "<option value=" + 3 + " >" + "3";
		selectOptions7[4] = "<option value=" + 4 + " >" + "4";
		selectOptions7[5] = "<option value=" + 5 + " >" + "5";
		selectOptions7[6] = "<option value=" + 6 + " >" + "6";
		selectOptions7[7] = "<option value=" + 7 + " >" + "7";
		tableHtmlOutput += "<td align=center  ><select name='codecList7'>" + selectOptions7.join("") + "<\/select></td>";  
<% end if %>
<% if tcwebApi_get("WebCustom_Entry","isVoipPortReverseSupported","h") = "Yes" then %>
		var selectOptions6 = Array();
		selectOptions6[0] = "<option value=" + 0 + " >" + "0";
		selectOptions6[1] = "<option value=" + 1 + " >" + "1";
		selectOptions6[2] = "<option value=" + 2 + " >" + "2";
		selectOptions6[3] = "<option value=" + 3 + " >" + "3";
		selectOptions6[4] = "<option value=" + 4 + " >" + "4";
		selectOptions6[5] = "<option value=" + 5 + " >" + "5";
		selectOptions6[6] = "<option value=" + 6 + " >" + "6";
		selectOptions6[7] = "<option value=" + 7 + " >" + "7";
		tableHtmlOutput += "<td align=center  ><select name='codecList6' id='codecList6'>" + selectOptions6.join("") + "<\/select></td>";
<% end if %>
		tableHtmlOutput += "</tr>"; 
		
		// Ptime row
		tableHtmlOutput += "<tr class=\"table-header center\">";
		tableHtmlOutput += "<td class=\"p-1\">RTP Ptime<\/td>"
<% if tcwebApi_get("WebCustom_Entry","isVoipPortReverseSupported","h") <> "Yes" then %>
		var selectOptions0 = Array();
		selectOptions0[0] = "<option value=10 <%if tcWebApi_get("VoIPCodecs_PVC0", "SIPPacketizationTime", "h") = "10" then  asp_Write("selected") end if %>>" + 10;
		selectOptions0[1] = "<option value=20 <%if tcWebApi_get("VoIPCodecs_PVC0", "SIPPacketizationTime", "h") = "20" then  asp_Write("selected") end if %>>" + 20;
		selectOptions0[2] = "<option value=30 <%if tcWebApi_get("VoIPCodecs_PVC0", "SIPPacketizationTime", "h") = "30" then  asp_Write("selected") end if %>>" + 30;
		tableHtmlOutput += "<td align=center><select name='voicePtime0'>" + selectOptions0.join("") + "<\/select></td>";
<% end if %>
<% if tcwebApi_get("VoIPBasic_Common","VoIPLine2Enable","h") = "Yes" then %>
		var selectOptions1 = Array();
		selectOptions1[0] = "<option value=10 <%if tcWebApi_get("VoIPCodecs_PVC1", "SIPPacketizationTime", "h") = "10" then asp_Write("selected") end if %>>" + 10;
		selectOptions1[1] = "<option value=20 <%if tcWebApi_get("VoIPCodecs_PVC1", "SIPPacketizationTime", "h") = "20" then asp_Write("selected") end if %>>" + 20;
		selectOptions1[2] = "<option value=30 <%if tcWebApi_get("VoIPCodecs_PVC1", "SIPPacketizationTime", "h") = "30" then asp_Write("selected") end if %>>" + 30;
		tableHtmlOutput += "<td align=center><select name='voicePtime1'>" + selectOptions1.join("") + "<\/select></td>";
<% end if %>
<% if tcwebApi_get("WebCustom_Entry","isVoipPortReverseSupported","h") = "Yes" then %>
		var selectOptions0 = Array();
		selectOptions0[0] = "<option value=10 <%if tcWebApi_get("VoIPCodecs_PVC0", "SIPPacketizationTime", "h") = "10" then  asp_Write("selected") end if %>>" + 10;
		selectOptions0[1] = "<option value=20 <%if tcWebApi_get("VoIPCodecs_PVC0", "SIPPacketizationTime", "h") = "20" then  asp_Write("selected") end if %>>" + 20;
		selectOptions0[2] = "<option value=30 <%if tcWebApi_get("VoIPCodecs_PVC0", "SIPPacketizationTime", "h") = "30" then  asp_Write("selected") end if %>>" + 30;
		tableHtmlOutput += "<td align=center><select name='voicePtime0'>" + selectOptions0.join("") + "<\/select></td>";
<% end if %>

		tableHtmlOutput += "</tr>";

	//End of table
	tableHtmlOutput += "</tbody></table>";
	document.getElementById("perLineTablePlaceholder1").innerHTML = tableHtmlOutput;
	}
}
function CheckPriority()
{
    document.getElementById("codecList0").selectedIndex = 	"<%if tcWebApi_get("VoIPCodecs_PVC0_Entry0", "priority", "h") <> "N/A" then tcWebAPI_get("VoIPCodecs_PVC0_Entry0", "priority", "s") else asp_Write("0") end if %>";
    document.getElementById("codecList2").selectedIndex = 	"<%if tcWebApi_get("VoIPCodecs_PVC0_Entry1", "priority", "h") <> "N/A" then tcWebAPI_get("VoIPCodecs_PVC0_Entry1", "priority", "s") else asp_Write("0") end if %>";
    document.getElementById("codecList4").selectedIndex = 	"<%if tcWebApi_get("VoIPCodecs_PVC0_Entry2", "priority", "h") <> "N/A" then tcWebAPI_get("VoIPCodecs_PVC0_Entry2", "priority", "s") else asp_Write("0") end if %>";
    document.getElementById("codecList6").selectedIndex = 	"<%if tcWebApi_get("VoIPCodecs_PVC0_Entry3", "priority", "h") <> "N/A" then tcWebAPI_get("VoIPCodecs_PVC0_Entry3", "priority", "s") else asp_Write("0") end if %>";
    <% if tcwebApi_get("VoIPBasic_Common","VoIPLine2Enable","h") = "Yes" then %>
    document.getElementById("codecList1").selectedIndex = 	"<%if tcWebApi_get("VoIPCodecs_PVC1_Entry0", "priority", "h") <> "N/A" then tcWebAPI_get("VoIPCodecs_PVC1_Entry0", "priority", "s") else asp_Write("0") end if %>"; 
    document.getElementById("codecList3").selectedIndex = 	"<%if tcWebApi_get("VoIPCodecs_PVC1_Entry1", "priority", "h") <> "N/A" then tcWebAPI_get("VoIPCodecs_PVC1_Entry1", "priority", "s") else asp_Write("0") end if %>";
    document.getElementById("codecList5").selectedIndex = 	"<%if tcWebApi_get("VoIPCodecs_PVC1_Entry2", "priority", "h") <> "N/A" then tcWebAPI_get("VoIPCodecs_PVC1_Entry2", "priority", "s") else asp_Write("0") end if %>"; 	
    document.getElementById("codecList7").selectedIndex = 	"<%if tcWebApi_get("VoIPCodecs_PVC1_Entry3", "priority", "h") <> "N/A" then tcWebAPI_get("VoIPCodecs_PVC1_Entry3", "priority", "s") else asp_Write("0") end if %>";
    <% end if %>
}
function on_load()
{
	with(document.VoipAdvanceSetForm)
	{
		var sessionEnable = <%if tcWebApi_get("VoIPBasic_Common", "SC_ACCT_SIP_SESSION_FLAG", "h") = "1" then asp_Write("1") else asp_Write("0")  end if %> ;
		if (sessionEnable == "1")
		{
			document.getElementById("seessionExpireTime").style.display = "";
		}
		else
		{
			document.getElementById("seessionExpireTime").style.display = "none";
		}
		generatePerLineTable();
		CheckPriority();
	}
}

</script>
</body>
</html>