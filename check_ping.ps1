### Script variables

$HostAddress = $args[0]
$Latency = $args[1]
$PacketLoss = $args[2]


### Test the packet loss

$count= 4
$con = Test-Connection $HostAddress -count $count
$average = ($con.ResponseTime | Measure-Object -Average).Average
$lost = $count-($con.count)
$lostPer = $lost/$count*100



### Test latency and if ping is sucesfull 

$PingStatus = Test-NetConnection $HostAddress
$PingLatency = $PingStatus.PingReplyDetails.RoundtripTime
Write-Output "$PingLatency"


if ($PingStatus.PingSucceeded -eq $false) {
    Write-Output "CRITICAL: Ping failed"
    }



elseif ($PingStatus.PingSucceeded -eq $True -and $PingStatus.PingReplyDetails.RoundtripTime -lt $Latency -and $lostPer -lt $PacketLoss ) {
    Write-Output "OK: Packet loss = $lostPer% , Latency = $PingLatency ms" 
    }





else {
    Write-Output "CRITICAL: Packet loss = $lostPer% , Latency = $PingLatency ms"
    }
    
