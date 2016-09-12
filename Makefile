all:
	go build -ldflags="-w" -o bin/github-webhook-handler
	chmod +x bin/*

clean:
	rm -f bin/*
	rm -f *.deb

release: clean
	GOOS=linux GOARCH=amd64 go build -ldflags="-w" -o bin/github-webhook-handler
	fpm \
		-s dir \
		-t deb \
		-n github-webhook-handler \
		--description "Github webhook server by @adnanh (https://github.com/adnanh), Packaging added by @wjessop (https://github.com/wjessop/)" \
		--url https://github.com/wjessop/webhook \
		-a amd64 \
		-v $(VERSION) \
		-C . \
		--license MIT \
		--maintainer "Will Jessop <will@willj.net>" \
		--prefix /usr/local \
		-p github-webhook-handler-$(VERSION).deb \
		bin
