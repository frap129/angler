#!/system/bin/sh
# -=zeppelinrox=- KSM baby...
line=================================================
echo ""
uptime=`awk -F. '{print $1}' /proc/uptime`
uphours=$(($uptime/3600))
upmins=$(($uptime/60%60))
upsecs=$(($uptime%60))
idletime=`awk -F [" "\.] '{print $3}' /proc/uptime`
idhours=$(($idletime/3600))
idmins=$(($idletime/60%60))
idsecs=$(($idletime%60))
waketime=`awk '{sum+=$2} END {printf "%.0f\n", sum/100}' /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state`
whours=$(($waketime/3600))
wmins=$(($waketime/60%60))
wsecs=$(($waketime%60))
deepsleep=$((uptime-waketime))
dshours=$(($deepsleep/3600))
dsmins=$(($deepsleep/60%60))
dssecs=$(($deepsleep%60))
if [ -f "/sys/kernel/mm/uksm/run" ]; then ksmdir=uksm; KSM=UKSM
elif [ -f "/sys/kernel/mm/ksm/run" ]; then ksmdir=ksm; KSM=KSM
else KSM=KSM
fi
echo $line
echo "Data DeDuping $KSM " | awk -F, '{printf "%28s", $1}'
if [ "$ksmdir" ]; then
	if [ "`cat /sys/kernel/mm/$ksmdir/run`" -eq 1 ]; then
		fullscans=`cat /sys/kernel/mm/$ksmdir/full_scans`
		if [ "$fullscans" -ne 0 ]; then
			shared=`cat /sys/kernel/mm/$ksmdir/pages_shared`
			sharing=`cat /sys/kernel/mm/$ksmdir/pages_sharing`
			unshared=`cat /sys/kernel/mm/$ksmdir/pages_unshared`
			sleepmills=`cat /sys/kernel/mm/$ksmdir/sleep_millisecs`
			pool=`echo $shared | awk '{printf "%.02f\n", $1/256}'`
			deduped=`echo $sharing | awk '{printf "%.02f\n", $1/256}'`
			duped=`echo $unshared | awk '{printf "%.02f\n", $1/256}'`
			secondsperscan=$((waketime/fullscans))
			minsperscan=$((secondsperscan/60))
			secsperscan=$((secondsperscan%60))
			ksmrunsperscan=`echo $secondsperscan $sleepmills | awk '{printf "%.02f\n", $1/$2*1000}'`
			ksmrunspermin=$((1000*60/sleepmills))
			echo "savings - $deduped MB!"
			echo $line
			echo " `echo $sharing $shared $unshared | awk '{printf "%.02f\n", $1*$1/$2/$3}'` = Benefit/Cost Ratio -> HIGHER IS BETTER!"
			echo " `echo $sharing $shared | awk '{printf "%.02f\n", $1/$2}'` Benefit Ratio x Shared $pool MB = $deduped MB"
			echo " `echo $unshared $sharing | awk '{printf "%.02f\n", $1/$2}'` Cost Ratio x $deduped MB = $duped MB (Unique)"
			echo " $fullscans - Full Scans SINCE BOOT."
			echo " $minsperscan min $secsperscan secs ($secondsperscan seconds) Needed Per Scan"
			echo " $KSM Executes $ksmrunsperscan Times Per Full Scan"
			echo $line
			echo " $KSM Per Minute Summary (Based on Awake Time)"
			echo "     $KSM Executes $ksmrunspermin Times."
			echo "`echo $sharing $secondsperscan | awk '{printf "%10.02f %s\n", $1/256*60/$2,"MB"}'` - Scanned Beneficially Per Minute."
			echo "`echo $unshared $secondsperscan | awk '{printf "%10.02f %s\n", $1/256*60/$2,"MB"}'` - Scanned Wastefully Per Minute."
		else echo "is On... But BORKEN!"
		fi
		echo $line
		echo ""
		echo " Current $KSM Values:"
		echo " ==================="
		echo ""
		for i in /sys/kernel/mm/*ksm*/*; do echo "`basename $i` - " | awk -F, '{printf "%25s", $1}'; cat $i; done
		echo ""
	else echo "is NOT Enabled!"
	fi
else echo "is NOT AVAILABLE!"
fi
echo $line
echo "          System Awake Time is `echo $whours $wmins $wsecs | awk '{printf "%0d:%02d:%02d\n", $1,$2,$3}'`"
echo $line
echo "           System Idle Time is `echo $idhours $idmins $idsecs | awk '{printf "%0d:%02d:%02d\n", $1,$2,$3}'`"
echo $line
echo "     System Deep Sleep Time is `echo $dshours $dsmins $dssecs | awk '{printf "%0d:%02d:%02d\n", $1,$2,$3}'`"
echo $line
echo "             System Up Time is `echo $uphours $upmins $upsecs | awk '{printf "%0d:%02d:%02d\n", $1,$2,$3}'`"
echo $line
echo ""

