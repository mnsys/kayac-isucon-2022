HOST3=isucon@52.69.16.88

TIMEID := $(shell date +%Y%m%d-%H%M%S)

# https://github.com/hirosuzuki/perf-logs-viewer
# https://github.com/hirosuzuki/go-sql-logger
# https://github.com/mnsys/isucon10q-etude

build:
	go build -o isucon

deploy: build
	ssh ${HOST3} sudo systemctl stop isucon || true
	scp isucon ${HOST3}:/home/isucon/webapp/golang/isucon
	scp env.sh ${HOST3}:/home/isucon/webapp/golang/env.sh
	cat isucon.service | ssh ${HOST3} sudo tee /etc/systemd/system/isucon.service >/dev/null
	ssh ${HOST3} sudo systemctl daemon-reload
	ssh ${HOST3} sudo systemctl start isucon

deploy-3-web:
	cat nginx/nginx.conf | ssh ${HOST3} sudo tee /etc/nginx/nginx.conf >/dev/null
	cat nginx/default | ssh ${HOST3} sudo tee /etc/nginx/sites-available/default >/dev/null
	ssh ${HOST3} sudo nginx -t
	ssh ${HOST3} sudo systemctl restart nginx	

host3:
	ssh ${HOST3}
