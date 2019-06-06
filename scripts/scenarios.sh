#! /bin/sh

GATEWAY=localhost:1330
RUST_LOG=trace,simple_raft_node=info,raft=info
RUST_BACKTRACE=1

if [ -z "$1" ] || [ ! -d "scenarios/$1" ]
then
    echo "The scenario $1 does not exist!"
    exit 1
fi

tmux new-session -d -s "$1" \
     "RUST_LOG=$RUST_LOG RUST_BACKTRACE=$RUST_BACKTRACE NODE_ID=0 NODE_ADDRESS=localhost:1330 NODE_GATEWAY=$GATEWAY WAMP_ADDRESS=0.0.0.0:8090 cargo run"
tmux select-window -t "$1:1"
sleep 1
tmux split-window -v -t 1 \
     "RUST_LOG=$RUST_LOG RUST_BACKTRACE=$RUST_BACKTRACE NODE_ID=1 NODE_ADDRESS=localhost:1331 NODE_GATEWAY=$GATEWAY WAMP_ADDRESS=0.0.0.0:8091 cargo run"
tmux split-window -h -t 1 \
     "RUST_LOG=$RUST_LOG RUST_BACKTRACE=$RUST_BACKTRACE NODE_ID=2 NODE_ADDRESS=localhost:1332 NODE_GATEWAY=$GATEWAY WAMP_ADDRESS=0.0.0.0:8092 cargo run"
tmux split-window -h -t 3 -c "scenarios/$1" "zsh"
tmux -2 attach-session -t "$1"
