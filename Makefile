all: pi-sdeb bmv2-sdeb p4c-sdeb

p4c:
	git clone --recurse-submodules --depth=1 -b v1.2.2.3 https://github.com/p4lang/p4c p4c
	rm -rf p4c/debian
	cp -r p4lang-p4c p4c/debian

bmv2:
	git clone --recurse-submodules --depth=1 -b 1.15.0 https://github.com/p4lang/behavioral-model bmv2
	rm -rf bmv2/debian
	cp -r p4lang-bmv2 bmv2/debian

pi:
	git clone --recurse-submodules --depth=1 -b v0.1.0 https://github.com/p4lang/PI pi
	rm -rf pi/debian
	cp -r p4lang-pi pi/debian

############################
# Install build dependencies
############################

p4c-install-deps: p4c
	cd p4c && \
	mk-build-deps -t "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y" -i -r

bmv2-install-deps: bmv2
	cd bmv2 && \
	mk-build-deps -t "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y" -i -r

pi-install-deps: pi
	cd pi && \
	mk-build-deps -t "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y" -i -r

#######################
# Build binary packages
########################

p4c-deb: p4c-install-deps
	cd p4c && \
	dpkg-buildpackage -us -uc

bmv2-deb: bmv2-install-deps
	cd bmv2 && \
	dpkg-buildpackage -us -uc

pi-deb: pi-install-deps
	cd pi && \
	dpkg-buildpackage -us -uc

########################
# Build source packages
########################

p4c-sdeb: p4c-install-deps
	cd p4c && \
	debuild --no-tgz-check -uc -us -sa

bmv2-sdeb: bmv2-install-deps
	cd bmv2 && \
	debuild --no-tgz-check -uc -us -sa

pi-sdeb: pi-install-deps
	cd pi && \
	debuild --no-tgz-check -uc -us -sa

clean:
	rm -rf p4c bmv2 pi
	if [ -d "p4c" ]; then cd p4c && git clean -dfx; fi
	if [ -d "bmv2" ]; then cd bmv2 && git clean -dfx; fi
	if [ -d "pi" ]; then cd pi && git clean -dfx; fi

.PHONY: p4c-install-deps bmv2-install-deps pi-install-deps p4c-deb p4c-sdeb bv2-deb bv2-sdeb pi-deb pi-sdeb clean