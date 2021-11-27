all:

p4c:
	git clone --recurse-submodules --depth=1 -b main https://github.com/p4lang/p4c p4c
	rm -rf p4c/debian
	cp -r p4lang-p4c p4c/debian

bmv2:
	git clone --recurse-submodules --depth=1 -b main https://github.com/p4lang/behavioral-model bmv2
	rm -rf bmv2/debian
	cp -r p4lang-bmv2 bmv2/debian

pi:
	git clone --recurse-submodules --depth=1 -b main https://github.com/p4lang/PI pi
	rm -rf pi/debian
	cp -r p4lang-pi pi/debian

p4c-bin-deb: p4c
	cd p4c && \
	dpkg-buildpackage -us -uc

bmv2-bin-deb: bmv2
	cd bmv2 && \
	dpkg-buildpackage -us -uc

pi-bin-deb: pi
	cd pi && \
	dpkg-buildpackage -us -uc

clean:
	rm -rf p4c bmv2 pi

.PHONY: p4c-bin-deb bv2-bin-deb pi-bin-deb clean