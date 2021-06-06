#!/bin/sh
# clear datadir
# run
# generate 
# getaddr
# sendto*2
# getwallet
# generate
# getwallet
bcli() {
  ~/exec2/bin/bitcoin-cli -conf=/home/silver/mycoin/pcoin/bt/bt.conf -rpcuser=admin -rpcpassword=1234 -rpcconnect="$@"
}
#
rm -rf ~/mycoin/pcoin/bt/data
mkdir ~/mycoin/pcoin/bt/data
rsync -av --delete ~/mycoin/pcoin/bt we23:~/mycoin/pcoin/
rsync -av --delete ~/mycoin/pcoin/bt we24:~/mycoin/pcoin/
#
ssh we22 "export LD_LIBRARY_PATH=/home/silver/exec2/lib && ~/exec2/bin/bitcoind -conf=/home/silver/mycoin/pcoin/bt/bt.conf"
ssh we23 "export LD_LIBRARY_PATH=/home/silver/exec2/lib && ~/exec2/bin/bitcoind -conf=/home/silver/mycoin/pcoin/bt/bt.conf"
ssh we24 "export LD_LIBRARY_PATH=/home/silver/exec2/lib && ~/exec2/bin/bitcoind -conf=/home/silver/mycoin/pcoin/bt/bt.conf"
#
sleep 30
bcli we22 getblockcount
bcli we23 getblockcount
bcli we24 getblockcount
bcli we22 addnode we23 add
bcli we22 addnode we24 add
bcli we23 addnode we24 add
bcli we23 addnode we22 add
bcli we24 addnode we23 add
bcli we24 addnode we22 add
sleep 60
#
bcli we22 generate 101
a1=`bcli we23 getnewaddress`
a2=`bcli we24 getnewaddress`
bcli we22 sendtoaddress $a1 5
bcli we22 sendtoaddress $a2 7
sleep 5
bcli we23 getwalletinfo
bcli we24 getwalletinfo
bcli we22 generate 1
sleep 5
bcli we23 getwalletinfo
bcli we24 getwalletinfo
