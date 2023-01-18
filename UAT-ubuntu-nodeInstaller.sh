#!/bin/bash
if [ "$(id -u)" != "0" ]; then  
   echo "This script must be run as root or with sudo cmd" 1>&2  
   exit 1  
   else
   URS=$(echo $HOME)
    installcmd() {
        
        if ! which git > /dev/null 2>&1; then
        cd $URS
        apt-get update -y && apt-get install git -y
        fi

URS=$(echo $HOME)
cd $URS
        rm -rf $URS/UAT-blockchain
        if [ ! -d $URS/UAT-blockchain ]
            then
                git clone  https://github.com/PEER-Inc/UAT-blockchain.git
        fi 
        rm -rf $URS/.peer
        if [ ! -d $URS/.peer ]
            then
                mkdir $URS/.peer
                cd $URS/UAT-blockchain
                cp  customSpecRaw.json $URS/.peer/customSpecRaw.json
                chmod +x peer
                cp peer /usr/bin/
            else
                cd UAT-blockchain
		echo $PWD
                    if [ ! -f $URS/.peer/customSpecRaw.json ]
                        then
                            cd $URS/UAT-blockchain
                            mv  customSpecRaw.json $URS/.peer/customSpecRaw.json
                            chmod +x peer
                            cp peer /usr/bin/
                    fi      
        fi
 }
 
peercmd(){
    if [ -x /usr/bin/peer ]
       	        then
       	        cd $URS/UAT-blockchain
                chmod +x peer
                cp peer /usr/bin/
                echo "peer is ready to run"
            else
                cd $URS/UAT-blockchain
                chmod +x peer
                cp peer /usr/bin/
     fi
    
}
    checkdir(){
       mkdir /data
        }

    listdir(){
        cd /data
        echo "Last node name "
        for i in $(find /data -name chains -type d |cut -f3 -d '/'); do echo -e " ${i}" ; done
       # find /data -name chains -type d |cut -f3 -d '/'
}

    peerconnect(){
        while [ -z $x ]
            do
                echo "Enter Your Node Name: "
                read x

            if [ -z "$x" ]
            then
                 echo "Please enter your node name it can't be null"
            fi
            done
        num=$(( ( RANDOM % 2 )  + 1 ))
        echo $num
case $num in
	1)
	peer --base-path /data/"${x}" --chain $URS/.peer/customSpecRaw.json   --port 30333   --ws-external   --rpc-external --rpc-cors all  --no-telemetry --validator   --rpc-methods Unsafe --name "${x}"   --bootnodes /ip4/13.52.78.111/tcp/30333/p2p/12D3KooWQrmErZ185u8vycFpzVqUs1BMPgfhnYxkTqWUGP64xF8n
		;;
    2)
	peer --base-path /data/"${x}" --chain $URS/.peer/customSpecRaw.json   --port 30333   --ws-external   --rpc-external --rpc-cors all  --no-telemetry --validator   --rpc-methods Unsafe --name "${x}"   --bootnodes /ip4/13.52.78.111/tcp/30333/p2p/12D3KooWQrmErZ185u8vycFpzVqUs1BMPgfhnYxkTqWUGP64xF8n
		;;
	
esac
}

dir=/data

    if [ ! -d  $dir ]
        then
	        checkdir
            if [ -x /usr/bin/peer ]
       	        then
                echo "peer is ready to run"
            else
                installcmd
                peercmd
            fi
                peerconnect 
                exit 1 
    else
            installcmd	
            peercmd
            listdir
            peerconnect 
            exit 1        
    fi
 fi  
