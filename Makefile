HOST0=isucon@52.197.181.153
HOST1=isucon@35.79.118.71
HOST2=isucon@13.114.36.63
HOST3=isucon@52.69.16.88

TIMEID := $(shell date +%Y%m%d-%H%M%S)

# https://github.com/hirosuzuki/perf-logs-viewer
# https://github.com/hirosuzuki/go-sql-logger
# https://github.com/mnsys/isucon10q-etude

build:
	go build -o isucon


deploy: build
	ssh ${HOST1} sudo systemctl stop isucon.go
	scp isucon ${HOST1}:~/isuumo/webapp/go/isucon
	#scp env.sh ${HOST1}:~/env.sh
	#scp 0_Schema.sql ${HOST1}:~/isuumo/webapp/mysql/db/0_Schema.sql
	#scp 3_Schema.sql ${HOST1}:~/isuumo/webapp/mysql/db/3_Schema.sql
	#cat host1-isucon.go.service | ssh ${HOST1} sudo tee /etc/systemd/system/isucon.go.service >/dev/null
	#ssh ${HOST1} sudo systemctl daemon-reload
	ssh ${HOST1} sudo systemctl start isucon.go

host0:
	ssh ${HOST0}

host1:
	ssh ${HOST1}

host2:
	ssh ${HOST2}

host3:
	ssh -L 13306:127.0.0.1:3306 ${HOST3}

fetch-conf:
	mkdir -p files
	scp ${HOST1}:/etc/systemd/system/isuumo.go.service files
	scp ${HOST1}:/etc/nginx/nginx.conf files
	scp ${HOST1}:/etc/mysql/my.cnf files
	scp ${HOST1}:/home/isucon/webapp/golang/*.go .
	scp ${HOST1}:/home/isucon/webapp/golang/go.* .


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
