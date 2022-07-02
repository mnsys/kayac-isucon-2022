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

deploy-1-web:
	ssh ${HOST1} docker-compose -f webapp/docker-compose.yml down
	scp docker-compose.yml ${HOST1}:/home/isucon/webapp/docker-compose.yml
	ssh ${HOST1} docker-compose -f webapp/docker-compose.yml up -d
	cat nginx/nginx.conf | ssh ${HOST1} sudo tee /etc/nginx/nginx.conf >/dev/null
	cat nginx/default | ssh ${HOST1} sudo tee /etc/nginx/sites-available/default >/dev/null
	ssh ${HOST1} sudo nginx -t
	ssh ${HOST1} sudo systemctl restart nginx	

perf-logs-viewer:
	# go install https://github.com/hirosuzuki/perf-logs-viewer:latest
	perf-logs-viewer

pprof:
	go tool pprof -http="127.0.0.1:8081" logs/latest/cpu-web1.pprof

collect-logs:
	mkdir -p logs/${TIMEID}
	rm -f logs/latest
	ln -sf ${TIMEID} logs/latest
	scp ${HOST1}:/tmp/cpu.pprof logs/latest/cpu-web1.pprof
	ssh ${HOST1} sudo chmod 644 /var/log/nginx/access.log
	scp ${HOST1}:/var/log/nginx/access.log logs/latest/access-web1.log
	scp ${HOST1}:/tmp/sql.log logs/latest/sql-web1.log
	ssh ${HOST1} sudo truncate -c -s 0 /var/log/nginx/access.log
	ssh ${HOST1} sudo truncate -c -s 0 /tmp/sql.log

truncate-logs:
	ssh ${HOST1} sudo truncate -c -s 0 /var/log/nginx/access.log
	ssh ${HOST1} sudo truncate -c -s 0 /tmp/sql.log
