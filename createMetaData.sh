#!/bin/bash
# SCRIPT:  createWoolz.sh
# PURPOSE: Create woolz files for processed files

FILENAME="/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/FLshow.txt"
count=0
proc=0

. /disk/data/VFB/IMAGE_DATA/Janelia2012/TG/script/initVars.bsh
logFile=$baseDir"/logs/Woolz.log"
proFile=$baseDir"/logs/FLwoolz.txt"
metaTemp=$stacksDir"flylight/wlz_meta_warped/tiledImageModelData.jso"

rm $stacksDir/flylight/index*.txt
rm $stacksDir/flylight/index*.htm
rm $stacksDir/flylight/full.*


cat $FILENAME | while read LINE
do
       	let count++
       	echo "$count $LINE"
   		echo "Creating..."
   		dl=${LINE##/*flylight-}
   		dl=${dl%-GMR*}
        echo $dl
   		script=${stacksDir}flylight-${dl}.jso
   		echo $script
   		cp $metaTemp $script
   		dl=${dl//"-"/"/"}
   		wlzpath1=${dl%/*}
   		if [ $wlzpath1 == "9" ]
   		then
   		    wlzpath2=${dl:2}
   		else
   		    wlzpath2=${dl:3}
   		fi
   		
   		p1=${LINE%'_'*}
   		p1=20${p1##/*_C}
   		p2=${LINE##/*AE_01-}
   		p3=${p2}'_ch2_total.jpg?height=42&width=42'
   		p0='http://flimg.janelia.org:8080/flylight-image/external-data/adult/secdata/projections/'${p1}'/'${p2}'/'${p3}
   		
   		
   		echo $wlzpath1 - $wlzpath2
                sedcmd="-i s/WLZ_PATH1/$wlzpath1/g;s/WLZ_PATH2/$wlzpath2/g"
                echo $sedcmd
   		sed $sedcmd $script #-i "s/WLZ_PATH1/${wlzpath1}/g;s/WLZ_PATH2/${wlzpath2}/" $script 
   		
   		if [ -f  $script ]
		then
		    echo generating meta data: SUCCESS
		    echo $script'tiledImageModelData.jso', generating meta data: SUCCESS, $(date +%F\ %X.%N) >> $logFile
		    let proc++	
		    cd $stacksDir/flylight/
		    lsmf=${wlzpath2:4}
		    lsmf=${lsmf%'_A'*}
		    #lsmf='../../../../../../flylight/'${wlzpath1}'/'${wlzpath2}'/*v_*.gz'
		    #lsm=$(echo $lsmf)
		    lsm='http://flweb.janelia.org/cgi-bin/view_flew_imagery.cgi?line=R'$lsmf
		    echo lsm
		    echo '<tr><td><a href="'$lsm'">'$lsmf'</a></td><td><a href="http://vfbsandbox.inf.ed.ac.uk/site/tools/view_stack/warpedStack.htm?woolz=Janelia2012_TG/'$wlzpath1'/'$wlzpath2'/wlz_meta/tiledImageModelData.jso">'$wlzpath2'</a></td></tr>' >> $stacksDir/flylight/full.txt
		    #echo '<tr><td><a href="http://vfbsandbox.inf.ed.ac.uk/site/tools/view_stack/warpedStack.htm?woolz=Janelia2012_TG/'$wlzpath1'/'$wlzpath2'/wlz_meta/tiledImageModelData.jso">'$wlzpath2'</a></td><td><a href="'$lsm'"><img src="'$wlzpath1'/'$wlzpath2'/LSMthumb.gif"  alt="Original '$wlzpath2'.lsm" height="42"></a></td><td><a href="http://vfbsandbox.inf.ed.ac.uk/site/tools/view_stack/warpedStack.htm?woolz=Janelia2012_TG/'$wlzpath1'/'$wlzpath2'/wlz_meta/tiledImageModelData.jso"><img src="http://vfbsandbox.inf.ed.ac.uk/fcgi/wlziipsrv.fcgi?wlz=/usr/local/tomcat-6/webapps/vfbStacks/stacks/Janelia2012_TG/'$wlzpath1'/'$wlzpath2'/wlz/BG.wlz&fxp=512,512,38&scl=0.03&mod=statue&dst=0&pit=0&yaw=90&rol=0&qlt=80&CVT=gif"  alt="'$wlzpath2' Warped" height="42"></a></td><td><a href="http://vfbsandbox.inf.ed.ac.uk/site/tools/view_stack/warpedStack.htm?woolz=Janelia2012_TG/'$wlzpath1'/'$wlzpath2'/wlz_meta/tiledImageModelData.jso"><img src="http://vfbsandbox.inf.ed.ac.uk/fcgi/wlziipsrv.fcgi?wlz=/usr/local/tomcat-6/webapps/vfbStacks/stacks/Janelia2012_TG/'$wlzpath1'/'$wlzpath2'/wlz/SG.wlz&fxp=512,512,38&scl=0.03&mod=statue&dst=0&pit=0&yaw=90&rol=0&qlt=80&CVT=gif"  alt="'$wlzpath2' Warped" height="42"></a></td></tr>' >> $stacksDir/flylight/index$wlzpath1.txt
		    echo '<tr><td><a href="http://vfbsandbox.inf.ed.ac.uk/site/tools/view_stack/warpedStack.htm?woolz=Janelia2012_TG/'$wlzpath1'/'$wlzpath2'/wlz_meta/tiledImageModelData.jso">'$wlzpath2'</a></td><td><a href="'$lsm'"><img src="'$p0'"  alt="Original '$wlzpath2'.lsm" height="42"></a></td><td><a href="http://vfbsandbox.inf.ed.ac.uk/site/tools/view_stack/warpedStack.htm?woolz=Janelia2012_TG/'$wlzpath1'/'$wlzpath2'/wlz_meta/tiledImageModelData.jso"><img src="http://vfbsandbox.inf.ed.ac.uk/fcgi/wlziipsrv.fcgi?wlz=/usr/local/tomcat-6/webapps/vfbStacks/stacks/Janelia2012_TG/'$wlzpath1'/'$wlzpath2'/wlz/BG.wlz&fxp=512,512,38&scl=0.03&mod=statue&dst=0&pit=0&yaw=90&rol=0&qlt=80&CVT=gif"  alt="'$wlzpath2' Warped" height="42"></a></td><td><a href="http://vfbsandbox.inf.ed.ac.uk/site/tools/view_stack/warpedStack.htm?woolz=Janelia2012_TG/'$wlzpath1'/'$wlzpath2'/wlz_meta/tiledImageModelData.jso"><img src="http://vfbsandbox.inf.ed.ac.uk/fcgi/wlziipsrv.fcgi?wlz=/usr/local/tomcat-6/webapps/vfbStacks/stacks/Janelia2012_TG/'$wlzpath1'/'$wlzpath2'/wlz/SG.wlz&fxp=512,512,38&scl=0.03&mod=statue&dst=0&pit=0&yaw=90&rol=0&qlt=80&CVT=gif"  alt="'$wlzpath2' Warped" height="42"></a></td></tr>' >> $stacksDir/flylight/index$wlzpath1.txt
		    cd $stacksDir/../logs/
		else
		    echo generating meta data: FAILED
		    echo $script'tiledImageModelData.jso', generating meta data: FAILED, $(date +%F\ %X.%N) >> $logFile 	
		fi
				
		
			    		   		
	
	echo "--------------------------------------------------"
	echo "  $proc out of $count files have been processed"
	echo "--------------------------------------------------"
done
list=""
for i in 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
do
    if [ -e $stacksDir/flylight/index$i.txt ]
    then
        list=$list"<a href=index"$i".htm>"$i"</a>,"
    fi
done

# <a href=index9.htm>9</a>,<a href=index10.htm>10</a>,<a href=index11.htm>11</a>,<a href=index12.htm>12</a>,<a href=index13.htm>13</a>,<a href=index14.htm>14</a>,<a href=index15.htm>15</a>,<a href=index16.htm>16</a>,<a href=index17.htm>17</a>,<a href=index18.htm>18</a>,<a href=index19.htm>19</a>,<a href=index20.htm>20</a>,<a href=index21.htm>21</a>,<a href=index22.htm>22</a>,<a href=index23.htm>23</a>,<a href=index24.htm>24</a>,<a href=index25.htm>25</a>,<a href=index26.htm>26</a>,<a href=index27.htm>27</a>,<a href=index28.htm>28</a>,<a href=index29.htm>29</a>,<a href=index30.htm>30</a>,<a href=index31.htm>31</a>,<a href=index32.htm>32</a>,<a href=index33.htm>33</a>,<a href=index34.htm>34</a>,<a href=index35.htm>35</a>,<a href=index36.htm>36</a>,<a href=index37.htm>37</a>,<a href=index38.htm>38</a>,<a href=index39.htm>39</a>,<a href=index40.htm>40</a>,<a href=index41.htm>41</a>,<a href=index42.htm>42</a>,<a href=index43.htm>43</a>,<a href=index44.htm>44</a>,<a href=index45.htm>45</a>,<a href=index46.htm>46</a>,<a href=index47.htm>47</a>,<a href=index48.htm>48</a>,<a href=index49.htm>49</a>,<a href=index50.htm>50</a>,<a href=index51.htm>51</a>,<a href=index52.htm>52</a>,<a href=index53.htm>53</a>,<a href=index54.htm>54</a>,<a href=index55.htm>55</a>,<a href=index56.htm>56</a>,<a href=index57.htm>57</a>,<a href=index58.htm>58</a>,<a href=index59.htm>59</a>,<a href=index60.htm>60</a>,<a href=index61.htm>61</a>,<a href=index62.htm>62</a>,<a href=index63.htm>63</a>,<a href=index64.htm>64</a>,<a href=index65.htm>65</a>,<a href=index66.htm>66</a>,<a href=index67.htm>67</a>,<a href=index68.htm>68</a>,<a href=index69.htm>69</a>,<a href=index70.htm>70</a>,<a href=index71.htm>71</a>,<a href=index72.htm>72</a>,<a href=index73.htm>73</a>,<a href=index74.htm>74</a>,<a href=index75.htm>75</a>,<a href=index76.htm>76</a>,<a href=index77.htm>77</a>,<a href=index78.htm>78</a>,<a href=index79.htm>79</a>,<a href=index80.htm>80</a>,<a href=index81.htm>81</a>,<a href=index82.htm>82</a>,<a href=index83.htm>83</a>,<a href=index84.htm>84</a>,<a href=index85.htm>85</a>,<a href=index86.htm>86</a>,<a href=index87.htm>87</a>,<a href=index88.htm>88</a>,<a href=index89.htm>89</a>,<a href=index90.htm>90</a>,<a href=index91.htm>91</a>,<a href=index92.htm>92</a>,<a href=index93.htm>93</a>,<a href=index94.htm>94</a>,<a href=index95.htm>95</a>.

for i in 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
do
    echo "<html><head><title>Flylight Data</title><h1>Flylight Data</h1></head><body>"$list"<br><table border="1">" > $stacksDir/flylight/index$i.htm  
    sort -u $stacksDir/flylight/index$i.txt >> $stacksDir/flylight/index$i.htm
    echo "</table></body></html>" >> $stacksDir/flylight/index$i.htm
done

echo "<html><head><title>Flylight Data</title><h1>Flylight Data</h1></head><body><br><table border=1><tr><td>ORIGINAL</td><td>WARPED</td></tr>" > $stacksDir/flylight/full.htm
sort -u $stacksDir/flylight/full.txt >> $stacksDir/flylight/full.htm
echo "</table></body></html>" >> $stacksDir/flylight/full.htm  



