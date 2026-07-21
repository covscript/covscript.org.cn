#!/bin/bash
export PATH="$HOME/.local/node/bin:$PATH"
trap 'kill $(jobs -p) 2>/dev/null' EXIT
ECS_FLAGS="-f -u UTF8"

rm -rf ./.ecs_output
rm -f ./*.csp
cspkg build ./deps/covscript-network/netutils.ecs --compile &
npm install && npm run build &
wait

ecs $ECS_FLAGS ./servers/sandbox.ecs ./configs/sandbox.json --logging > sandbox.log 2>&1 &
ecs $ECS_FLAGS ./servers/web.ecs ./configs/web.json --logging > web.log 2>&1 &
echo "Service start successfully. Visit http://localhost:8080 to access the web service."
wait
