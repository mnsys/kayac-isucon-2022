HOST1=isucon@35.79.118.71

TIMEID := $(shell date +%Y%m%d-%H%M%S)

# https://github.com/hirosuzuki/perf-logs-viewer
# https://github.com/hirosuzuki/go-sql-logger
# https://github.com/mnsys/isucon10q-etude

build:
	go build -o isucon

deploy: build
	ssh ${HOST1} sudo systemctl stop isucon || true
	scp isucon ${HOST1}:/home/isucon/webapp/golang/isucon
	scp env.sh ${HOST1}:/home/isucon/webapp/golang/env.sh
	cat isucon.service | ssh ${HOST1} sudo tee /etc/systemd/system/isucon.service >/dev/null
	ssh ${HOST1} sudo systemctl daemon-reload
	ssh ${HOST1} sudo systemctl start isucon

host1:
	ssh ${HOST1}
