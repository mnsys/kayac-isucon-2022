HOST2=isucon@13.114.36.63

TIMEID := $(shell date +%Y%m%d-%H%M%S)

# https://github.com/hirosuzuki/perf-logs-viewer
# https://github.com/hirosuzuki/go-sql-logger
# https://github.com/mnsys/isucon10q-etude

build:
	go build -o isucon

deploy: build
	ssh ${HOST2} sudo systemctl stop isucon || true
	scp isucon ${HOST2}:/home/isucon/webapp/golang/isucon
	scp env.sh ${HOST2}:/home/isucon/webapp/golang/env.sh
	cat isucon.service | ssh ${HOST2} sudo tee /etc/systemd/system/isucon.service >/dev/null
	ssh ${HOST2} sudo systemctl daemon-reload
	ssh ${HOST2} sudo systemctl start isucon

HOST2:
	ssh ${HOST2}
