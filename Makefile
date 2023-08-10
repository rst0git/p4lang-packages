all: pi-sdeb bmv2-sdeb p4c-sdeb

p4c:
	git clone --recurse-submodules -b main https://github.com/p4lang/p4c p4c
	rm -rf p4c/debian
	cp -r p4lang-p4c p4c/debian

bmv2:
	git clone --recurse-submodules -b main https://github.com/p4lang/behavioral-model bmv2
	rm -rf bmv2/debian
	cp -r p4lang-bmv2 bmv2/debian

pi:
	git clone --recurse-submodules -b main https://github.com/p4lang/PI pi
	rm -rf pi/debian
	cp -r p4lang-pi pi/debian

############################
# Install build dependencies
############################

p4c-install-deps: p4c
	cd p4c && \
	git checkout 624c6be8076881e9af1e2f7d7691bc6c4416f4b1 && \
	mkdir -p fetch_content build && cd fetch_content && \
	cmake .. \
		-DCMAKE_BUILD_TYPE=RELEASE \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DENABLE_BMV2=ON \
		-DENABLE_EBPF=ON \
		-DENABLE_UBPF=ON \
		-DENABLE_DPDK=ON \
		-DENABLE_P4C_GRAPHS=ON \
		-DENABLE_P4TEST=ON \
		-DENABLE_DOCS=OFF \
		-DENABLE_GC=ON \
		-DENABLE_GTESTS=OFF \
		-DENABLE_PROTOBUF_STATIC=ON \
		-DENABLE_MULTITHREAD=OFF \
		-DENABLE_TEST_TOOLS=ON || (echo "CMake configuration failed" && exit 1) && \
	cd .. && \
	rm -rf fetch_content/_deps/*-build fetch_content/_deps/*-subbuild && \
	for src_folder in fetch_content/_deps/*-src; do \
		if [ -d "$$src_folder/.git"  ]; then \
			(cd "$$src_folder" && git clean -dfx) || (echo "Git clean failed" && exit 1); \
		fi; \
	done && \
	cp -r fetch_content/_deps build/ && \
	rm -rf fetch_content && \
	mk-build-deps -t "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y" -i -r

bmv2-install-deps: bmv2
	cd bmv2 && \
	git checkout 6ee70b5eff7f510b32c074aaa4f00358f594fecb && \
	mk-build-deps -t "apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y" -i -r

pi-install-deps: pi
	cd pi && \
	git checkout e86801b69a51fc3462ed67ac2f7fa6762e827460 && \
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
