#!/bin/bash
if [ "$(id -u)" != "0" ]; then  
   echo "This script must be run as root or with sudo cmd" 1>&2  
   exit 1  
   else
   URS=$(echo $HOME)
    installcmd() {
        
        if ! which git > /dev/null 2>&1; then
        cd $URS
        brew update -y && brew install git -y
        fi

URS=$(echo $HOME)
cd $URS
        rm -rf $URS/UAT-blockchain
        if [ ! -d $URS/UAT-blockchain ]
            then
                git clone  https://github.com/PEER-Inc/UAT-blockchain.git
 		cd  $URS/UAT-blockchain 
		git checkout mac_binary
        fi 
        rm -rf $URS/.peer
        if [ ! -d $URS/.peer ]
            then
                mkdir $URS/.peer
                cd $URS/UAT-blockchain
                cp  customSpecRaw.json $URS/.peer/customSpecRaw.json
                chmod +x peer
                if [ -d /usr/local/bin/ ]
       	        then
                    cp peer /usr/local/bin/
                else
                    mkdir -p /usr/local/bin/
                    cp peer /usr/local/bin/
                fi
            else
		echo $PWD
                    if [ ! -f $URS/.peer/customSpecRaw.json ]
                        then
                            cd $URS/UAT-blockchain
                            mv  customSpecRaw.json $URS/.peer/customSpecRaw.json
                            chmod +x peer
                    if [ -d /usr/local/bin/ ]
       	            then
                        cp peer /usr/local/bin/
                    else
                        mkdir -p /usr/local/bin/
                        cp peer /usr/local/bin/
                    fi
                    fi      
        fi
 }
 
peercmd(){
    if [ -x /usr/bin/peer ]
       	        then
                echo "peer is ready to run"
            else
                cd $URS/UAT-blockchain
                chmod +x peer
                                if [ -d /usr/local/bin/ ]
       	        then
                    cp peer /usr/local/bin/
                else
                    mkdir -p /usr/local/bin/
                    cp peer /usr/local/bin/
                fi
     fi
    
}
    checkdir(){
       mkdir /data
        }

    listdir(){
        cd /opt
        for i in $(find /opt -name chains -type d |cut -f3 -d '/'); do echo "Last Dir. \n ${i}" ; done
       # find /opt -name chains -type d |cut -f3 -d '/'
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
        num=$(( $RANDOM % 2 + 1 ))
         echo $num
case $num in
	1)
	peer --base-path /opt/"${x}" --chain $URS/.peer/customSpecRaw.json   --port 30333   --ws-external   --rpc-external --rpc-cors all  --no-telemetry --validator   --rpc-methods Unsafe --name "${x}"   --bootnodes /ip4/13.52.78.111/tcp/30333/p2p/12D3KooWQrmErZ185u8vycFpzVqUs1BMPgfhnYxkTqWUGP64xF8n
		;;
    2)
	peer --base-path /opt/"${x}" --chain $URS/.peer/customSpecRaw.json   --port 30333   --ws-external   --rpc-external --rpc-cors all  --no-telemetry --validator   --rpc-methods Unsafe --name "${x}"   --bootnodes /ip4/13.52.78.111/tcp/30333/p2p/12D3KooWQrmErZ185u8vycFpzVqUs1BMPgfhnYxkTqWUGP64xF8n
		;;
esac
}

dir=/opt

    if [ ! -d  $dir ]
        then
	        checkdir
            if [ -x /usr/local/bin/peer ]
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
            if [ -x /usr/local/bin/peer ]
       	        then
                echo "peer is ready to run"
            else
                installcmd
                peercmd
            fi
            peercmd
            listdir
            peerconnect 
            exit 1        
    fi
 fi 