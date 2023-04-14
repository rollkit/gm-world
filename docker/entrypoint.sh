#!/bin/sh

# print all commands before executing them
set -x

# create a random Namespace ID for your rollup to post blocks to
NAMESPACE_ID=$(echo $RANDOM | md5sum | head -c 16; echo)
echo "NAMESPACE_ID: $NAMESPACE_ID"

# query the DA Layer start height, in this case we are querying
# our local devnet at port 26657, the RPC. The RPC endpoint is
# to allow users to interact with Celestia's nodes by querying
# the node's state and broadcasting transactions on the Celestia
# network. The default port is 26657.
DA_BLOCK_HEIGHT=$(curl --silent ${RPC%/}${RPC:+/}block | jq -r '.result.block.header.height')
echo "DA_BLOCK_HEIGHT: $DA_BLOCK_HEIGHT"

if [ -z "$DA_BLOCK_HEIGHT" ]; then
    echo "DA_BLOCK_HEIGHT is empty; ensure that the DA Layer is running and accessible"
    exit 1
fi

exec gmd start --rollkit.aggregator true --rollkit.da_layer celestia --rollkit.da_config='{"base_url":"http://celestia:26659","timeout":60000000000,"fee":6000,"gas_limit":6000000}' --rollkit.namespace_id $NAMESPACE_ID --rollkit.da_start_height $DA_BLOCK_HEIGHT $START_ARGS
