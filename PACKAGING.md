# How to package the webhook server

1. Run a bundle install:

		$ bundle

2. Check out the last tag (or whichever tag you want to package):

		$ git checkout tags/$(git tag -l | tail -n1)

	or if you want to cut a release:

		$ git checkout tags/$(git tag -l | tail -n1)


3. Run the release makefile task:

		$ VERSION=$(git tag -l | tail -n1).rc1 make release
		rm -f bin/*
		rm -f *.deb
		GOOS=linux GOARCH=amd64 go build -ldflags="-w" -o bin/github-webhook-handler
		fpm \
				-s dir \
				-t deb \
				-n github-webhook-handler \
				--description "Github webhook server by @adnanh (https://github.com/adnanh), Packaging added by @wjessop (https://github.com/wjessop/)" \
				--url https://github.com/wjessop/webhook \
				-a amd64 \
				-v 2.4.0.rc1 \
				-C . \
				--license MIT \
				--maintainer "Will Jessop <will@willj.net>" \
				--prefix /usr/local \
				-p github-webhook-handler-2.4.0.rc1.deb \
				bin
		Debian packaging tools generally labels all files in /etc as config files, as mandated by policy, so fpm defaults to this behavior for deb packages. You can disable this default behavior with --deb-no-default-config-files flag {:level=>:warn}
		Debian packaging tools generally labels all files in /etc as config files, as mandated by policy, so fpm defaults to this behavior for deb packages. You can disable this default behavior with --deb-no-default-config-files flag {:level=>:warn}
		Created package {:path=>"github-webhook-handler-2.4.0.rc1.deb"}

4. Sanity check the generated package information:

		$ dpkg -I github-webhook-handler-2.4.0.rc1.deb
		new debian package, version 2.0.
		size 1720092 bytes: control archive=495 bytes.
		   382 bytes,    11 lines      control
		   155 bytes,     2 lines      md5sums
		Package: github-webhook-handler
		Version: 2.4.0.rc1
		License: MIT
		Vendor: will@tomato.home
		Architecture: amd64
		Maintainer: Will Jessop <will@willj.net>
		Installed-Size: 4614
		Section: default
		Priority: extra
		Homepage: https://github.com/wjessop/webhook
		Description: Github webhook server by @adnanh (https://github.com/adnanh), Packaging added by @wjessop (https://github.com/wjessop/)

	And the files it will install:

		$ dpkg -c github-webhook-handler-2.4.0.rc1.deb
		drwx------ 0/0               0 2016-09-12 19:16 ./
		drwxr-xr-x 0/0               0 2016-09-12 19:16 ./usr/
		drwxr-xr-x 0/0               0 2016-09-12 19:16 ./usr/local/
		drwxr-xr-x 0/0               0 2016-09-12 19:16 ./usr/local/bin/
		-rwxr-xr-x 0/0         4725041 2016-09-12 19:16 ./usr/local/bin/github-webhook-handler
		drwxr-xr-x 0/0               0 2016-09-12 19:16 ./usr/share/
		drwxr-xr-x 0/0               0 2016-09-12 19:16 ./usr/share/doc/
		drwxr-xr-x 0/0               0 2016-09-12 19:16 ./usr/share/doc/github-webhook-handler/
		-rw-r--r-- 0/0             161 2016-09-12 19:16 ./usr/share/doc/github-webhook-handler/changelog.gz
