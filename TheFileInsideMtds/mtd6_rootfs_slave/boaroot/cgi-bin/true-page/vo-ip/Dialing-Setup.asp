<%
If request_Form("Dialing_Flag_Value")="1" then
	tcWebApi_constSet("WebCurSet_Entry", "VoIPIdle", "1")
	if tcWebApi_get("VoIPBasic_Entry0", "Enable", "h") = "Yes"  then
		if tcWebApi_get("VoIPSysParam_Entry0", "SC_LINE_INFO_STATUS", "h") <> "Idle"  then
			tcWebApi_constSet("WebCurSet_Entry", "VoIPIdle", "0")
		end if
	end if
	
	if tcWebApi_get("WebCurSet_Entry", "VoIPIdle", "h") = "1"  then
		tcWebApi_set("VoIPAdvanced_Common", "NumberMatchMode", "DivDigitMatchMethod")
		tcWebApi_set("VoIPDigitMap_Entry", "InterDigitTimerShort", "megacodmshorttime")
		tcWebApi_set("VoIPDigitMap_Entry", "InterDigitTimerLong", "megacodmlongtime")
		
		tcWebApi_set("VoIPDigitMap_Entry", "DigitMapEnable", "Digitmap_Flag_Value")
		if Request_Form("isMultiDigitMap") = "1" then
		tcWebApi_set("VoIPDigitMap_Entry", "DigitMap1", "DigitMap1")	
		tcWebApi_set("VoIPDigitMap_Entry", "DigitMap2", "DigitMap2")	
		tcWebApi_set("VoIPDigitMap_Entry", "DigitMap3", "DigitMap3")	
		tcWebApi_set("VoIPDigitMap_Entry", "DigitMap4", "DigitMap4")	
		tcWebApi_set("VoIPDigitMap_Entry", "DigitMap5", "DigitMap5")	
		tcWebApi_set("VoIPDigitMap_Entry", "DigitMap6", "DigitMap6")	
		tcWebApi_set("VoIPDigitMap_Entry", "DigitMap7", "DigitMap7")	
		tcWebApi_set("VoIPDigitMap_Entry", "DigitMap8", "DigitMap8")	

		tcWebApi_commit("VoIPDigitMap_Entry")
	else
		tcWebApi_set("VoIPAdvanced_Common", "DialPlan", "dialPlan")
	end if

	tcWebApi_commit("VoIPAdvanced_Common")
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
  <title>VoIP - Dialing Setup</title>
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
	function on_load()
	{
		<% if tcWebApi_get("WebCustom_Entry","isMultiDigitMap","h") = "Yes" then %>
		getDigitMapValue();
		<%end if%>
		document.getElementById('txt_DigitMap').value=document.getElementById('dialPlan').value;
		<% if tcWebApi_get("WebCustom_Entry", "isCTSCSupported", "h") = "Yes"  then %>	
		<% if tcwebApi_get("WanInfo_Common","NoGUIAccessLimit","h" ) <> "1" then %>
			document.getElementById('txt_DigitMap').disabled = true;
		<% end if %>
		<%end if%>
	}
	function OnApplyDialing()
	{
		var regDigitMap = /[^0-9\[\]\-\|\.\*#xXABCDTLStlsEF]/g;
		if(document.getElementById("cb_DigitMapEnable").checked)
		{
			Digitmap_Flag_Value.value = "1";
			if(regDigitMap.test(document.getElementById('txt_DigitMap').value)){
				alert('Invaild characters in special digit map.');
				return;
			}
			document.getElementById('dialPlan').value=document.getElementById('txt_DigitMap').value;
<% if tcWebApi_get("WebCustom_Entry","isMultiDigitMap","h") = "Yes" then %>
            setDigitMapValue();
<% end if %>
		}
		else
		{
			Digitmap_Flag_Value.value = "0";
		}
		with(document.VoipDialingSetForm)
		{
			document.VoipDialingSetForm.SaveAlter_Flag.value = "1";
			document.VoipDialingSetForm.Dialing_Flag_Value.value = 1;
			document.VoipDialingSetForm.submit();
		}
	}
  </script>
</head>
<body onload="on_load()">
	<div class="container-full container-resize-height">
		<div class="title-text">Dialing Setup</div>
		<div class="title-description-text">On this page, you can modify the broadband telephone dialing parameters.</div>
		<form name="VoipDialingSetForm" action="/cgi-bin/true-page/vo-ip/Dialing-Setup.asp" method="post">
			<input type="hidden" name="SaveAlter_Flag" value="0">
			<input type='hidden' value='0' id="Dialing_Flag_Value" name="Dialing_Flag_Value">
			<input type='hidden' value='0' id="Digitmap_Flag_Value" name="Digitmap_Flag_Value">
			<div style="display:none;">				
				<% if tcWebApi_get("WebCustom_Entry","isMultiDigitMap","h") = "Yes" then %>
				<input type='text' name='dialPlan' id='dialPlan' value="">
				<% else %>
				<input type='text' name='dialPlan' value="<%if tcWebApi_get("VoIPAdvanced_Common", "DialPlan", "h") <> "N/A" then tcWebAPI_get("VoIPAdvanced_Common", "DialPlan", "s") else asp_Write("") end if %>">
				<%end if%>
				<input type="hidden" name="isMultiDigitMap" value="<% if tcWebApi_get("WebCustom_Entry","isMultiDigitMap","h") = "Yes" then asp_write("1") else asp_write("0") end if %>">
				<% if tcWebApi_get("WebCustom_Entry","isMultiDigitMap","h") = "Yes" then %>
				<input type='hidden' id='DigitMap1' name="DigitMap1" value="<%tcWebAPI_get("VoIPDigitMap_Entry", "DigitMap1", "s")%>">
				<input type='hidden' id='DigitMap2' name="DigitMap2" value="<%tcWebAPI_get("VoIPDigitMap_Entry", "DigitMap2", "s")%>">
				<input type='hidden' id='DigitMap3' name="DigitMap3" value="<%tcWebAPI_get("VoIPDigitMap_Entry", "DigitMap3", "s")%>">
				<input type='hidden' id='DigitMap4' name="DigitMap4" value="<%tcWebAPI_get("VoIPDigitMap_Entry", "DigitMap4", "s")%>">
				<input type='hidden' id='DigitMap5' name="DigitMap5" value="<%tcWebAPI_get("VoIPDigitMap_Entry", "DigitMap5", "s")%>">
				<input type='hidden' id='DigitMap6' name="DigitMap6" value="<%tcWebAPI_get("VoIPDigitMap_Entry", "DigitMap6", "s")%>">
				<input type='hidden' id='DigitMap7' name="DigitMap7" value="<%tcWebAPI_get("VoIPDigitMap_Entry", "DigitMap7", "s")%>">
				<input type='hidden' id='DigitMap8' name="DigitMap8" value="<%tcWebAPI_get("VoIPDigitMap_Entry", "DigitMap8", "s")%>">
				<% end if%>
				
			</div>
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Digitmap:</div>
				</div>
				<div class="col-6">
					<input type='checkbox'  id='cb_DigitMapEnable' name='cb_DigitMapEnable' <%if tcWebApi_get("VoIPDigitMap_Entry", "DigitMapEnable", "h") = "1" then asp_Write("checked") end if %> >
					<label class="input-radio">Enable</label>
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Dial Plan Rules:</div>
				</div>
				<div class="col-4">
					<textarea maxlength="1024" rows="1" id='txt_DigitMap' name='txt_DigitMap' wrap='OFF'></textarea>
				</div>
				<div class="col-1">
					<label class="input-radio" style="line-height: 30px; margin-bottom: 0px;">(Length:1024)</label>
				</div>		
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Match Mode:</div>
				</div>
				<div class="col-6">
					<select name="DivDigitMatchMethod"  class="form-control input-select" >
						<option value="0" <%if tcWebApi_get("VoIPAdvanced_Common", "NumberMatchMode", "h") = "0" then asp_Write("selected") end if %>>Minimum Match</option>
                        <option style="display:none" value="1" <%if tcWebApi_get("VoIPAdvanced_Common", "NumberMatchMode", "h") = "1" then asp_Write("selected") end if %>>Fuzzy Match</option>
						<option value="2" <%if tcWebApi_get("VoIPAdvanced_Common", "NumberMatchMode", "h") = "2" then asp_Write("selected") end if %>>Maximum Match</option>
					</select>
				</div>
			</div>
			

			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Long Timer:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" name='megacodmlongtime' onblur="limitNum(this)" value="<%if tcWebApi_get("VoIPDigitMap_Entry", "InterDigitTimerLong", "h") <> "N/A" then tcWebAPI_get("VoIPDigitMap_Entry", "InterDigitTimerLong", "s") else asp_Write("") end if %>">
				</div>
			</div>
			
			<div class="row p-1">
				<div class="col-6">
					<div class="title-text-left">Short Timer:</div>
				</div>
				<div class="col-6">
					<input type='text' class="form-control input-textfield" name='megacodmshorttime' onblur="limitNum(this)" value="<%if tcWebApi_get("VoIPDigitMap_Entry", "InterDigitTimerShort", "h") <> "N/A" then tcWebAPI_get("VoIPDigitMap_Entry", "InterDigitTimerShort", "s") else asp_Write("") end if %>">
				</div>
			</div>
			
			
			<div class="mt-2 center">
				<button id="apply" name="apply" type="button" class="btn-dashboard" onclick="OnApplyDialing();">Apply</button>
			</div>
		</form>
	</div>
<script>
<% if tcWebApi_get("WebCustom_Entry","isMultiDigitMap","h") = "Yes" then %>
function getDigitMapValue()
{
	if(document.getElementById("DigitMap1").value.length < 512){
		document.getElementById("dialPlan").value = document.getElementById("DigitMap1").value;
	}
	else if(document.getElementById("DigitMap2").value.length < 512){
		document.getElementById("dialPlan").value = document.getElementById("DigitMap1").value + document.getElementById("DigitMap2").value;
	}else if(document.getElementById("DigitMap3").value.length < 512){
		document.getElementById("dialPlan").value = document.getElementById("DigitMap1").value + 
																								document.getElementById("DigitMap2").value +
																								document.getElementById("DigitMap3").value;
	}else if(document.getElementById("DigitMap4").value.length < 512){
		document.getElementById("dialPlan").value = document.getElementById("DigitMap1").value + 
																								document.getElementById("DigitMap2").value +
																								document.getElementById("DigitMap3").value +
																								document.getElementById("DigitMap4").value;
	}else if(document.getElementById("DigitMap5").value.length < 512){
		document.getElementById("dialPlan").value = document.getElementById("DigitMap1").value + 
																								document.getElementById("DigitMap2").value +
																								document.getElementById("DigitMap3").value +
																								document.getElementById("DigitMap4").value +
																								document.getElementById("DigitMap5").value;
	}else if(document.getElementById("DigitMap6").value.length < 512){
		document.getElementById("dialPlan").value = document.getElementById("DigitMap1").value + 
																								document.getElementById("DigitMap2").value +
																								document.getElementById("DigitMap3").value +
																								document.getElementById("DigitMap4").value + 
																								document.getElementById("DigitMap5").value +
																								document.getElementById("DigitMap6").value;
	}else if(document.getElementById("DigitMap7").value.length < 512){
		document.getElementById("dialPlan").value = document.getElementById("DigitMap1").value + 
																								document.getElementById("DigitMap2").value +
																								document.getElementById("DigitMap3").value +
																								document.getElementById("DigitMap4").value +
																								document.getElementById("DigitMap5").value + 
																								document.getElementById("DigitMap6").value +
																								document.getElementById("DigitMap7").value;
	}else{
		document.getElementById("dialPlan").value = document.getElementById("DigitMap1").value + 
																								document.getElementById("DigitMap2").value +
																								document.getElementById("DigitMap3").value +
																								document.getElementById("DigitMap4").value +
																								document.getElementById("DigitMap5").value + 
																								document.getElementById("DigitMap6").value + 
																								document.getElementById("DigitMap7").value +
																								document.getElementById("DigitMap8").value;
	}		

}

function setDigitMapValue()
{
	var len = document.getElementById("dialPlan").value.length;
	var num = len/512;

	if(len > 4096){
		alert("Dial plan must be less than 4096 bytes!!!");
		return -1;
	}
	
	if(num < 1){
		document.getElementById("DigitMap1").value = document.getElementById("dialPlan").value;
		document.getElementById("DigitMap2").value = "";
	}else if(num < 2){
		document.getElementById("DigitMap1").value = document.getElementById("dialPlan").value.substring(0,512);
		document.getElementById("DigitMap2").value = document.getElementById("dialPlan").value.substring(512);		
		document.getElementById("DigitMap3").value = "";
	}else if(num < 3){
		document.getElementById("DigitMap1").value = document.getElementById("dialPlan").value.substring(0,512);
		document.getElementById("DigitMap2").value = document.getElementById("dialPlan").value.substring(512,512*2);
		document.getElementById("DigitMap3").value = document.getElementById("dialPlan").value.substring(512*2);
		document.getElementById("DigitMap4").value = "";
	}else if(num < 4){
		document.getElementById("DigitMap1").value = document.getElementById("dialPlan").value.substring(0,512);
		document.getElementById("DigitMap2").value = document.getElementById("dialPlan").value.substring(512,512*2);
		document.getElementById("DigitMap3").value = document.getElementById("dialPlan").value.substring(512*2,512*3);
		document.getElementById("DigitMap4").value = document.getElementById("dialPlan").value.substring(512*3);
		document.getElementById("DigitMap5").value = "";
	}else if(num < 5){
		document.getElementById("DigitMap1").value = document.getElementById("dialPlan").value.substring(0,512);
		document.getElementById("DigitMap2").value = document.getElementById("dialPlan").value.substring(512,512*2);
		document.getElementById("DigitMap3").value = document.getElementById("dialPlan").value.substring(512*2,512*3);
		document.getElementById("DigitMap4").value = document.getElementById("dialPlan").value.substring(512*3,512*4);
		document.getElementById("DigitMap5").value = document.getElementById("dialPlan").value.substring(512*4);
		document.getElementById("DigitMap6").value = "";
	}else if(num < 6){
		document.getElementById("DigitMap1").value = document.getElementById("dialPlan").value.substring(0,512);
		document.getElementById("DigitMap2").value = document.getElementById("dialPlan").value.substring(512,512*2);
		document.getElementById("DigitMap3").value = document.getElementById("dialPlan").value.substring(512*2,512*3);
		document.getElementById("DigitMap4").value = document.getElementById("dialPlan").value.substring(512*3,512*4);
		document.getElementById("DigitMap5").value = document.getElementById("dialPlan").value.substring(512*4,512*5);
		document.getElementById("DigitMap6").value = document.getElementById("dialPlan").value.substring(512*5);
		document.getElementById("DigitMap7").value = "";
	}else if(num < 7){
		document.getElementById("DigitMap1").value = document.getElementById("dialPlan").value.substring(0,512);
		document.getElementById("DigitMap2").value = document.getElementById("dialPlan").value.substring(512,512*2);
		document.getElementById("DigitMap3").value = document.getElementById("dialPlan").value.substring(512*2,512*3);
		document.getElementById("DigitMap4").value = document.getElementById("dialPlan").value.substring(512*3,512*4);
		document.getElementById("DigitMap5").value = document.getElementById("dialPlan").value.substring(512*4,512*5);
		document.getElementById("DigitMap6").value = document.getElementById("dialPlan").value.substring(512*5,512*6);
		document.getElementById("DigitMap7").value = document.getElementById("dialPlan").value.substring(512*6);
		document.getElementById("DigitMap8").value = "";
	}else if(num <= 8){
		document.getElementById("DigitMap1").value = document.getElementById("dialPlan").value.substring(0,512);
		document.getElementById("DigitMap2").value = document.getElementById("dialPlan").value.substring(512,512*2);
		document.getElementById("DigitMap3").value = document.getElementById("dialPlan").value.substring(512*2,512*3);
		document.getElementById("DigitMap4").value = document.getElementById("dialPlan").value.substring(512*3,512*4);
		document.getElementById("DigitMap5").value = document.getElementById("dialPlan").value.substring(512*4,512*5);
		document.getElementById("DigitMap6").value = document.getElementById("dialPlan").value.substring(512*5,512*6);
		document.getElementById("DigitMap7").value = document.getElementById("dialPlan").value.substring(512*6,512*7);
		document.getElementById("DigitMap8").value = document.getElementById("dialPlan").value.substring(512*7);
	}

   return 0;
}
<%end if%>
</script>
</body>
</html>