<%
If request_Form("VoIP_AppBtn_flag")="1" then
	tcWebApi_constSet("WebCurSet_Entry", "VoIPIdle", "1")
	
	If request_Form("VoIP_click_flag") = "1" then
		tcWebApi_set("VoIPBasic_Common", "SIPProtocol", "sipMode")
		tcWebApi_commit("VoIPBasic")
		tcWebApi_save()
	else
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
			tcWebApi_set("VoIPBasic_Common", "SIPProxyAddr", "proxyAddr")
			tcWebApi_set("VoIPBasic_Common", "SIPProxyPort", "proxyAddr_port")
			
			tcWebApi_set("VoIPBasic_Common", "RegistrarServer", "regAddr")
			tcWebApi_set("VoIPBasic_Common", "RegistrarServerPort", "regAddr_port")

			tcWebApi_set("VoIPBasic_Common", "SIPOutboundProxyAddr", "exproxyAddr")
			tcWebApi_set("VoIPBasic_Common", "SIPOutboundProxyPort", "exproxyAddr_port")

			tcWebApi_set("VoIPBasic_Common", "SBSIPProxyAddr", "secproxyAddr")
			tcWebApi_set("VoIPBasic_Common", "SBSIPProxyPort", "secproxyAddr_port")

			tcWebApi_set("VoIPBasic_Common", "SBRegistrarServer", "secregAddr")
			tcWebApi_set("VoIPBasic_Common", "SBRegistrarServerPort", "secregAddr_port")

			tcWebApi_set("VoIPBasic_Common", "SBOutboundProxyAddr", "secexproxyAddr")
			tcWebApi_set("VoIPBasic_Common", "SBOutboundProxyPort", "secexproxyAddr_port")
			
			tcWebApi_set("VoIPBasic_Entry0", "Enable", "enableLine1Flag")
			tcWebApi_set("VoIPBasic_Entry0", "SIPDisplayNumber", "Line1DisplayNum")
			tcWebApi_set("VoIPBasic_Entry0", "SIPResponseNumber", "Line1ResponseNum")
			tcWebApi_set("VoIPBasic_Entry0", "SIPAuthenticationName", "Line1Name")
			tcWebApi_set("VoIPBasic_Entry0", "SIPPassword", "Line1Pass")
			
			tcWebApi_commit("VoIPBasic")
			tcWebApi_save()
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
  <title>VoIP - Basic Setup</title>
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
	var line1radio = "<%if tcWebApi_get("VoIPBasic_Entry0", "Enable", "h") = "Yes" then asp_Write("Yes") else asp_Write("No") end if %>";
	var sm = "<%if tcWebApi_get("VoIPBasic_Common", "SIPProtocol", "h") = "SIP" then asp_Write("1") else asp_Write("0") end if %>";
	function clickLine1()
	{
		var line1Enable = document.getElementById("enableLine1");
		var Line1DisplayNum = document.getElementById("Line1DisplayNum");
		var Line1ResponseNum = document.getElementById("Line1ResponseNum");
		var line1Name =document.getElementById("Line1Name");
		var line1Pass =document.getElementById("Line1Pass");
		if(sm == "1")
		{
			if(line1Enable.checked == true )
			{
				line1Name.disabled = false;
				line1Pass.disabled = false;
				line1Enable.value = 'Yes';
			}
			else
			{
				line1Name.disabled = true;
				line1Pass.disabled = true;
				line1Enable.value = 'No';
			}
		}
		else
		{
			if(line1Enable.checked == true )
			{
				Line1DisplayNum.disabled = false;
				Line1ResponseNum.disabled = false;
				line1Name.disabled = false;
				line1Pass.disabled = false;
				line1Enable.value = 'Yes';
			}
			else
			{
				Line1DisplayNum.disabled = true;
				Line1ResponseNum.disabled = true;
				line1Name.disabled = true;
				line1Pass.disabled = true;
				line1Enable.value = 'No';
			}
		}
	}
	function on_load()
	{
		var line1Enable =document.getElementById("enableLine1");
		//console.log("current Line1Radio"+line1radio);
		if(sm == "1")
		{
			document.getElementById("DisplayNum").style.display="none";
			document.getElementById("ResponseNum").style.display="none";
		}
		else
		{
			document.getElementById("DisplayNum").style.display="";
			document.getElementById("ResponseNum").style.display="";
		}
		if(line1radio == "Yes")
		{
			line1Enable.checked = true;
		}
		else
		{
			line1Enable.checked = false;
		}
		clickLine1();
	}
	//CHECK FUNCTION ======================================================================================================START
	function isValidName_Bas(name) 
	{
		var i = 0;
		var unsafeString = "\"<>%\\^[]`\+\$\,='#&:;*/{} \t";
		for ( i = 0; i < name.length; i++ )
		{
			for( j = 0; j < unsafeString.length; j++)
				if ( (name.charAt(i)) == unsafeString.charAt(j) )
				return false;
		}
		for (k = 0; k < name.length; k++)
		{
			if (name.charAt(k) == '.')
			{
				break;
			}
		}
		if (k >= name.length - 1 || k == 0)
			return false;
	}
	function isValidIPV6(str)
	{
		var pattern = new RegExp("^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:)|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}(:[0-9A-Fa-f]{1,4}){1,2})|(([0-9A-Fa-f]{1,4}:){4}(:[0-9A-Fa-f]{1,4}){1,3})|(([0-9A-Fa-f]{1,4}:){3}(:[0-9A-Fa-f]{1,4}){1,4})|(([0-9A-Fa-f]{1,4}:){2}(:[0-9A-Fa-f]{1,4}){1,5})|([0-9A-Fa-f]{1,4}:(:[0-9A-Fa-f]{1,4}){1,6})|(:(:[0-9A-Fa-f]{1,4}){1,7})|(([0-9A-Fa-f]{1,4}:){6}(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3})|(([0-9A-Fa-f]{1,4}:){5}:(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3})|(([0-9A-Fa-f]{1,4}:){4}(:[0-9A-Fa-f]{1,4}){0,1}:(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3})|(([0-9A-Fa-f]{1,4}:){3}(:[0-9A-Fa-f]{1,4}){0,2}:(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3})|(([0-9A-Fa-f]{1,4}:){2}(:[0-9A-Fa-f]{1,4}){0,3}:(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3})|([0-9A-Fa-f]{1,4}:(:[0-9A-Fa-f]{1,4}){0,4}:(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3})|(:(:[0-9A-Fa-f]{1,4}){0,5}:(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3}))$");
		return pattern.test(str);
	}
	function isValidPort(port)
	{
		if (!isInteger(port) || port < 1025 || port > 65535)
		{
			return false;
		}
		
		return true;
	}
	function isValidAddress(address) 
	{
		// IPv4 地址
		const ipv4Pattern = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;

		if (ipv4Pattern.test(address)) {
			const parts = address.split('.').map(Number);
			const isMulticast = parts[0] >= 224 && parts[0] <= 239;
			const isLoopback = parts[0] === 127;
			const isBroadcast = parts[3] === 255;

			if (isMulticast || isLoopback || isBroadcast) {
				return false;
			}
			return true;
		}
		
		// IPv6 地址
		const ipv6Pattern = /^(([0-9a-fA-F]{1,4}:){7}([0-9a-fA-F]{1,4}|:)|(([0-9a-fA-F]{1,4}:){1,7}|:):|(([0-9a-fA-F]{1,4}:){1,6}|:):([0-9a-fA-F]{1,4}|:)|(([0-9a-fA-F]{1,4}:){1,5}|:)((:[0-9a-fA-F]{1,4}){1,2}|:)|(([0-9a-fA-F]{1,4}:){1,4}|:)((:[0-9a-fA-F]{1,4}){1,3}|:)|(([0-9a-fA-F]{1,4}:){1,3}|:)((:[0-9a-fA-F]{1,4}){1,4}|:)|(([0-9a-fA-F]{1,4}:){1,2}|:)((:[0-9a-fA-F]{1,4}){1,5}|:)|([0-9a-fA-F]{1,4}:|:)((:[0-9a-fA-F]{1,4}){1,6}|:)|:((:[0-9a-fA-F]{1,4}){1,7}|:))$/;

		// 多级域名
		const domainPattern = /^(?!:\/\/)([a-zA-Z0-9-_]+\.)+[a-zA-Z]{2,}$/;
		
		return ipv6Pattern.test(address) || domainPattern.test(address);
	}
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
	function check_ServerAddr(severAddr,port)
	{
		
		if (isValidName_Bas(severAddr.value) == false)
		{
			
			alert('address is invalid.');	
			return false;
		}
		
		if (!isValidAddress(severAddr.value)){
			alert('address is invalid!');
			return false;
		}
		if (port.value == "")
		{
			alert('port can not be empty!');
			return false;
		}
		return true;
	}
	//CHECK FUNCTION ======================================================================================================END
	
	function protocolClick(obj) {
		var idx = obj.selectedIndex;
		var val = obj.options[idx].value;
		var needSubmit=-1;
		if( val == "SIP") 
		{
			if(sm != "1")
			{
				needSubmit = 1;
			}
		}
		<% if tcWebApi_get("WebCustom_Entry", "isCTCUCSIPH248Supported", "h") = "Yes"  then %>
		else if(val == "H.248")
		{
			//TODO
		}
		<% end if %>
		else
		{
			if(sm != '0')
			{
				needSubmit = 1;
			}
		}
		if(needSubmit)
		{
			with(document.VoipBasicSetForm)
			{
				//if select trigger,both 
				document.VoipBasicSetForm.VoIP_AppBtn_flag.value = 1; 
				document.VoipBasicSetForm.VoIP_click_flag.value = 1;
				document.VoipBasicSetForm.submit();
			}
		}
	}
	function OnApplyBasic()
	{
		var line1Enable = document.getElementById("enableLine1");
		with(document.VoipBasicSetForm)
		{
			if(proxyAddr.value != "")
			{
				if (check_ServerAddr(proxyAddr,proxyAddr_port) == false)
				{
					return ;
				}
			}
			if(secproxyAddr.value != "")
			{
				if (check_ServerAddr(secproxyAddr,secproxyAddr_port) == false)
				{
					return ;
				}
			}
			if(regAddr.value != "")
			{
				if (check_ServerAddr(regAddr,regAddr_port) == false)
				{
					return ;
				}
			}
			if(secregAddr.value != "")
			{
				if (check_ServerAddr(secregAddr,secregAddr_port) == false)
				{
					return ;
				}
			}
			if(exproxyAddr.value != "")
			{
				if (check_ServerAddr(exproxyAddr,exproxyAddr_port) == false)
				{
					return ;
				}
			}
			if(secexproxyAddr.value != "")
			{
				if (check_ServerAddr(secexproxyAddr,secexproxyAddr_port) == false)
				{
					return ;
				}
			}
			if(line1Enable.checked)
			{
				var re=/[~!@#$%^&*()_+|?<>]/;   
                const chineseChar = /[\u4e00-\u9fa5]/;
				if (Line1Name.value == "")
				{
					alert('SIP Account can not be empty!');
					return;
				}
				if (Line1Name.value.indexOf("\"") >= 0)
				{
					alert('Invalid SIP Account!');
					return;
				}
				
				if (Line1Pass.value != "" && Line1Pass.value.indexOf("\"") >= 0)
				{
					alert('Invalid Passowrd!');
					return;
				}
                if(chineseChar.test(Line1Pass.value) || chineseChar.test(Line1Name.value))
                {
                    alert('Invalid Password or SIP Account! Please fill in again.');
                    return;
                }
                document.VoipBasicSetForm.enableLine1Flag.value = "Yes";
			}
			document.VoipBasicSetForm.SaveAlter_Flag.value = "1";
			document.VoipBasicSetForm.VoIP_AppBtn_flag.value = 1;
			document.VoipBasicSetForm.VoIP_click_flag.value = 0;
			document.VoipBasicSetForm.submit();
			//showLoading();
		}
	}
	function PasswordVisible() 
	{
		var pass=document.getElementById("Line1Pass");
		if(pass.disabled ==  false) 
		{
			if($("#Line1Pass").prop("type") == "password")
			{
				$('#Line1Pass').prop('type','text');
			}
			else
			{
				$('#Line1Pass').prop('type','password');
			}
		}
	}
</script>
</head>
<body onload="on_load()">
	<div class="container-full container-resize-height">
		<div class="title-text">Basic Setup</div>
		<div class="title-description-text">On this page, you can modify the basic parameters of the broadband phone.</div>
		<form name="VoipBasicSetForm" action="/cgi-bin/true-page/vo-ip/Basic-Setup.asp" method="post">	
			<input type='hidden' name="VoIP_click_flag"  value="0">
			<input type='hidden' name="VoIP_AppBtn_flag" value="0">
			<input type="hidden" name="SaveAlter_Flag" value="0">
            <input type="hidden" name="enableLine1Flag" value="No">
			<!---<input type='hidden' id="VoIP_basic_flag" name="VoIP_basic_flag" value="0">---->
			<!---<input type='hidden' name="VoIP_Protocol" id="VoIP_Protocol"  value="SIP">----->
			<div class="row p-1">
			  <div class="col-6">
				  <div class="title-text-left">Protocol:</div>
			  </div>
			  <div class="col-6">
				<select name="sipMode" id="mg_regist" class="form-control input-select"  onChange="protocolClick(this)">
					<option value="IMSSIP" <%if tcWebApi_get("VoIPBasic_Common", "SIPProtocol", "h") = "IMSSIP" then asp_Write("selected") end if %>>IMS SIP</option>
					<option value="SIP" <%if tcWebApi_get("VoIPBasic_Common", "SIPProtocol", "h") = "SIP" then asp_Write("selected") end if %>>SIP</option>
				</select>
			  </div>
			</div>	

			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Proxy Server:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" name='proxyAddr'  VALUE="<%if tcWebApi_get("VoIPBasic_Common", "SIPProxyAddr", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "SIPProxyAddr", "s") else asp_Write("") end if %>">
				</div>
			</div>
			
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Proxy Server Port:</div>
				</div>
				<div class="col-3">
					<input type='text' class="form-control input-textfield" name='proxyAddr_port' onblur="checkPort(this)" VALUE="<%if tcWebApi_get("VoIPBasic_Common", "SIPProxyPort", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "SIPProxyPort", "s") else asp_Write("") end if %>">
				</div>
				<div class="col-3 left">
				  <label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">[1025-65535]</label>
				</div>
			</div>
			
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Registration Server:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" name='regAddr'  VALUE="<%if tcWebApi_get("VoIPBasic_Common", "RegistrarServer", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "RegistrarServer", "s") else asp_Write("") end if %>">
				</div>
			</div>
			
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Registration Server Port:</div>
				</div>
				<div class="col-3">
					<input type='text' class="form-control input-textfield" name='regAddr_port' onblur="checkPort(this)" VALUE="<%if tcWebApi_get("VoIPBasic_Common", "RegistrarServerPort", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "RegistrarServerPort", "s") else asp_Write("") end if %>">
				</div>
				<div class="col-3 left">
				  <label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">[1025-65535]</label>
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">External Proxy Server:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" name='exproxyAddr'  VALUE="<%if tcWebApi_get("VoIPBasic_Common", "SIPOutboundProxyAddr", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "SIPOutboundProxyAddr", "s") else asp_Write("") end if %>">
				</div>
			</div>
			
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">External Proxy Server Port:</div>
				</div>
				<div class="col-3">
					<input type='text' class="form-control input-textfield" name='exproxyAddr_port' onblur="checkPort(this)" VALUE="<%if tcWebApi_get("VoIPBasic_Common", "SIPOutboundProxyPort", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "SIPOutboundProxyPort", "s") else asp_Write("") end if %>">
				</div>
				<div class="col-3 left">
				  <label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">[1025-65535]</label>
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Second Proxy Server:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" name='secproxyAddr'  VALUE="<%if tcWebApi_get("VoIPBasic_Common", "SBSIPProxyAddr", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "SBSIPProxyAddr", "s") else asp_Write("") end if %>">
				</div>
			</div>
			
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Second Proxy Server Port:</div>
				</div>
				<div class="col-3">
					<input type='text' class="form-control input-textfield" name='secproxyAddr_port' onblur="checkPort(this)" VALUE="<%if tcWebApi_get("VoIPBasic_Common", "SBSIPProxyPort", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "SBSIPProxyPort", "s") else asp_Write("") end if %>">
				</div>
				<div class="col-3 left">
				  <label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">[1025-65535]</label>
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Second Registration Server:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" name='secregAddr'  VALUE="<%if tcWebApi_get("VoIPBasic_Common", "SBRegistrarServer", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "SBRegistrarServer", "s") else asp_Write("") end if %>">
				</div>
			</div>
			
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Second Registration Server Port:</div>
				</div>
				<div class="col-3">
					<input type='text' class="form-control input-textfield" name='secregAddr_port' onblur="checkPort(this)" VALUE="<%if tcWebApi_get("VoIPBasic_Common", "SBRegistrarServerPort", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "SBRegistrarServerPort", "s") else asp_Write("") end if %>">
				</div>
				<div class="col-3 left">
				  <label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">[1025-65535]</label>
				</div>
			</div>
			
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Second External Proxy Server:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" name='secexproxyAddr'  VALUE="<%if tcWebApi_get("VoIPBasic_Common", "SBOutboundProxyAddr", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "SBOutboundProxyAddr", "s") else asp_Write("") end if %>">
				</div>
			</div>
			
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Second External Proxy Server Port:</div>
				</div>
				<div class="col-3">
					<input type='text' class="form-control input-textfield" name='secexproxyAddr_port' onblur="checkPort(this)" VALUE="<%if tcWebApi_get("VoIPBasic_Common", "SBOutboundProxyPort", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Common", "SBOutboundProxyPort", "s") else asp_Write("") end if %>">
				</div>
				<div class="col-3 left">
				  <label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">[1025-65535]</label>
				</div>
			</div>
			
			<!-----
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">SIP User Agent Domain:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" name='agentDomain' VALUE="current do not support" disabled>
				</div>
			</div>
			--------->
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Line1 Enable:</div>
				</div>
				<div class="col-6">
					<input type="checkbox" value="Yes" name="enableLine1" id="enableLine1" onclick="clickLine1()">
					<label class="input-radio">Enable</label>
				</div>
			</div>
			
			<div class="row p-1" id="DisplayNum">
				<div class="col-6">
					<div class="title-text-left">Line1 Display Number:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" size=20 maxlength=128 name='Line1DisplayNum' id='Line1DisplayNum' VALUE="<%if tcWebApi_get("VoIPBasic_Entry0", "SIPDisplayNumber", "h") <> "N/A" then tcWebApi_get("VoIPBasic_entry0","SIPDisplayNumber","s") else asp_Write("") end if %>">
				</div>
			</div>
			
			<div class="row p-1" id="ResponseNum">
				<div class="col-6">
					<div class="title-text-left">Line1 Response Number:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" size=20 maxlength=128 name='Line1ResponseNum' id='Line1ResponseNum' VALUE="<%if tcWebApi_get("VoIPBasic_Entry0", "SIPResponseNumber", "h") <> "N/A" then tcWebApi_get("VoIPBasic_entry0","SIPResponseNumber","s") else asp_Write("") end if %>">
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Line1 Username:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" size=20 maxlength=128 name='Line1Name' id='Line1Name' VALUE="<%if tcWebApi_get("VoIPBasic_Entry0", "SIPAuthenticationName", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Entry0", "SIPAuthenticationName", "s") else asp_Write("") end if %>">
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Line1 Password:</div>
				</div>
				<div class="col-4">
					<input type='password' class="form-control input-textfield" size=20 maxlength=128 name='Line1Pass' id='Line1Pass'  VALUE="<%if tcWebApi_get("VoIPBasic_Entry0", "SIPPassword", "h") <> "N/A" then tcWebAPI_get("VoIPBasic_Entry0", "SIPPassword", "s") else asp_Write("") end if %>">
				</div>
				<div class="col-2 left">
					<img src="/image/icon/visibility.svg" width="20" height="30" onclick="PasswordVisible()">
				</div>
			</div>
			
			<div class="mt-2 center">
				<button id="apply" name="apply" type="button" class="btn-dashboard" onclick="OnApplyBasic();">Save</button>
			</div>
		</form>
	</div>
</body>
</html>