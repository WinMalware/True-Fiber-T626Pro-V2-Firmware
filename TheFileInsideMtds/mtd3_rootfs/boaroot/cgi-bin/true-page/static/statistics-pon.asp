<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html lang="en" style="overflow: hidden;">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Statistics - PON</title>
  <!-- style -->
  <link rel="stylesheet" href="/css/bootstrap.min.css">
  <link rel="stylesheet" href="/css/style.min.css">
  <!-- style -->

  <!-- script -->
  <script src="/scripts/lib/jquery.min.js"></script>
  <script src="/scripts/lib/bootstrap.min.js"></script>
  <script src="/scripts/lib/bootstrap.bundle.min.js"></script>
  <!-- script -->
  <script>
        var ponStaArray = JSON.parse('<% tcWebApi_GetTable("Info","PonWanStats") %>');
        var ponStaData = ponStaArray[0];
        function PonStatusInfoClass()
        {
            this.TxFrameCnt			= ponStaData.TxFrameCnt || 0;
            this.TxFrameLen			= ponStaData.TxFrameLen || 0;
            this.TxDropCnt			= ponStaData.TxDropCnt || 0;
            this.TxBroadcastCnt		= ponStaData.TxBroadcastCnt || 0;
            this.TxMulticastCnt		= ponStaData.TxMulticastCnt || 0;
            this.TxUnicaseCnt		= this.TxFrameCnt - this.TxBroadcastCnt - this.TxMulticastCnt;
            
            this.RxFrameCnt			= ponStaData.RxFrameCnt || 0;
            this.RxFrameLen			= ponStaData.RxFrameLen || 0;
            this.RxDropCnt			= ponStaData.RxDropCnt || 0;
            this.RxBroadcastCnt		= ponStaData.RxBroadcastCnt || 0;
            this.RxMulticastCnt		= ponStaData.RxMulticastCnt || 0;
            this.RxHecErrorCnt		= ponStaData.RxHecErrorCnt || 0;
            this.RxFecErrorCnt		= ponStaData.RxFecErrorCnt || 0;
            this.RxUnicaseCnt		= this.RxFrameCnt - this.RxBroadcastCnt - this.RxMulticastCnt;
        }
        
		var PonStatusInfo = new PonStatusInfoClass();
        console.log(PonStatusInfo,'PonStatusInfo')
        console.log(document.ConfigForm,'document.ConfigForm')
        
  </script>
</head>

<body>
  <!-- content -->
  <div class="container-full container-resize-height">
    <div class="card-table">
        <div class="title-content">PON Statistics</div>
        <div class="title-description-content">This page shows the packet statistics for transmission and reception regarding to network interface.</div>
        <table style="width:100%">
            <tr class="table-header">
                <th colspan="2" class="p-1">PON Statistics</th>
            </tr>
            <tr class="table-content-fist">
                <td style="width: 50%;" class="table-header-content p-1">Byte Sent</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>" + PonStatusInfo.TxFrameLen + "</td>");
                </SCRIPT>
            </tr>
            <tr class="table-content-second">
                <td class="table-header-content p-1">Byte Received</td>
                <SCRIPT language=javascript>
                  document.writeln("<td>" + PonStatusInfo.RxFrameLen + "</td>");
                </SCRIPT>
            </tr>
            <tr class="table-content-fist">
                <td style="width: 50%;" class="table-header-content p-1">Packets Sent</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>" + PonStatusInfo.TxFrameCnt + "</td>");
                </SCRIPT>
            </tr>
            <tr class="table-content-second">
                <td class="table-header-content p-1">Packets Received</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>" + PonStatusInfo.RxFrameCnt + "</td>");
                </SCRIPT>
            </tr>
            <tr class="table-content-fist">
                <td style="width: 50%;" class="table-header-content p-1">Unicast Packets Sent</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>" + PonStatusInfo.TxUnicaseCnt + "</td>");
                </SCRIPT>
            </tr>
            <tr class="table-content-second">
                <td class="table-header-content p-1">Unicast Packets Received</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>" + PonStatusInfo.RxUnicaseCnt + "</td>");
                </SCRIPT>
            </tr>
            <tr class="table-content-fist">
                <td style="width: 50%;" class="table-header-content p-1">Multicast Packets Sent</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>" + PonStatusInfo.TxMulticastCnt + "</td>");
                </SCRIPT>
            </tr>
            <tr class="table-content-second">
                <td class="table-header-content p-1">Multicast Packets Received</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>" + PonStatusInfo.RxMulticastCnt + "</td>");
                </SCRIPT>
            </tr>
            <tr class="table-content-fist">
                <td style="width: 50%;" class="table-header-content p-1">Broadcast Packets Sent</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>" + PonStatusInfo.TxBroadcastCnt + "</td>");
                </SCRIPT>
            </tr>
            <tr class="table-content-second">
                <td class="table-header-content p-1">Broadcast Packets Received</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>" + PonStatusInfo.RxBroadcastCnt + "</td>");
                </SCRIPT>
            </tr>
            <tr class="table-content-fist">
                <td style="width: 50%;" class="table-header-content p-1">FEC Errors</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>" + PonStatusInfo.RxFecErrorCnt + "</td>");
                </SCRIPT>
            </tr>
            <tr class="table-content-second">
                <td class="table-header-content p-1">HEC Errors</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>" + PonStatusInfo.RxHecErrorCnt + "</td>");
                </SCRIPT>
            </tr>
            <tr class="table-content-fist">
                <td style="width: 50%;" class="table-header-content p-1">Packets Droped Sent</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>" + PonStatusInfo.TxDropCnt + "</td>");
                </SCRIPT>
            </tr>
            <tr class="table-content-fist">
                  <td style="width: 50%;" class="table-header-content p-1">Packets Droped Received</td>
                  <SCRIPT language=javascript>
                        document.writeln("<td>" + PonStatusInfo.RxDropCnt + "</td>");
                  </SCRIPT>
            </tr>
            <!--<tr class="table-content-second">
                <td class="table-header-content p-1">Pause Packets Sent</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>NA</td>");
                </SCRIPT>
            </tr>-->
            <!--<tr class="table-content-fist">
                <td style="width: 50%;" class="table-header-content p-1">Pause Packets Received</td>
                <SCRIPT language=javascript>
                      document.writeln("<td>NA</td>");
                </SCRIPT>
            </tr>-->
        </table>
    </div>
  </div>
  <!-- content -->
</body>

</html>