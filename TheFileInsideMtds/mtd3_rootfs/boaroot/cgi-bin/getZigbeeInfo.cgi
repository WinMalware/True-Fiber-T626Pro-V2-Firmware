#!/bin/sh

echo "Content-Type: text/html"
echo ""
SSWVer=`/userfs/bin/tcapi get DeviceInfo_devParaStatic CustomerSWVersion`
echo "<html><head><meta http-equiv=Content-Script-Type content=text/javascript><meta http-equiv=Content-Style-Type
content=text/css><meta http-equiv=Content-Type content=\"text/html; charset=UTF-8\"><link rel=\"stylesheet\" href=\"/JS/stylemain_skyw.css?v=$SSWVer\" type=\"text/css\">
<link rel=\"stylesheet\" href=\"/css/bootstrap.min.css\">
<link rel=\"stylesheet\" href=\"/css/style.min.css\">
<style>
body {
    background: #FFFFFF;
}
</style>
</head><SCRIPT language=javascript src=\"/JS/util_skyw.js?v=2\"></SCRIPT><script language=\"JavaScript\"></script>

<body>"

ZIGBEECHANNEL=$(cat /proc/tc3162/True_Zigbee_channel)

echo "<div class=\"container-full container-resize-height\">"
echo "<div class=\"card-table\"><table style=\"width:100%\">"
echo "<tr class=\"table-header\"><th colspan=\"2\" class=\"p-1\">Zigbee Info</th></tr>"
echo "<tr class=\"table-content-fist\"><td style=\"width: 50%;\" class=\"table-header-content p-1\">Channel</td><td style=\"width: 50%;\">$ZIGBEECHANNEL</td></tr>"
echo "</table></div>"

echo "<div class=\"card-table\"><div class=\"title-content\">Device Table</div><table style=\"width:100%\">"
echo "<tr class=\"table-header\"><th class=\"p-1 text-center border border-dark\">Device Name</th>
<th class=\"p-1 text-center border border-dark\">MAC ID</th>
<th class=\"p-1 text-center border border-dark\">version</th>
</tr>"
cat /tmp/zigbee_list | while read LINE
do
        VIRTUALID=$(echo $LINE | awk -F 'dev_name:' '{print $2}' | awk -F ',' '{print $1}')
        MACID=$(echo $LINE | awk -F 'id:' '{print $2}' | awk -F ',' '{print $1}')
        VERSION=$(echo $LINE | awk -F 'sw_ver:' '{print $2}' | awk -F ',' '{print $1}')
        echo "<tr align=\"middle\"><td class=\"text-center border border-dark\">$VIRTUALID</td><td class=\"text-center border border-dark\">$MACID</td><td class=\"text-center border border-dark\">$VERSION</td></tr>"
done
echo "</table></div>"

echo "</div></body></html>"

