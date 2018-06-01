# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

KEYWORDS="~amd64"
DESCRIPTION="Standard networking plugins for container networking"
EGO_PN="github.com/containernetworking/plugins"
HOMEPAGE="https://github.com/containernetworking/plugins"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="hardened"

src_compile() {
	pushd src || die
	local i
	for i in plugins/{meta/{flannel,portmap,tuning},main/{bridge,host-device,ipvlan,loopback,macvlan,ptp,vlan},ipam/{dhcp,host-local},sample}; do
		CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" GOPATH="${WORKDIR}/${P}" go install -v "${EGO_PN}/${i}"
	done
	popd || die
}

src_install() {
	exeinto /opt/cni/bin
	doexe bin/*
	pushd src/${EGO_PN} || die
	dodoc README.md
	local i
	for i in plugins/{meta/{flannel,portmap,tuning},main/{bridge,host-device,ipvlan,loopback,macvlan,ptp,vlan},ipam/{dhcp,host-local},sample}; do
		newdoc README.md ${i##*/}.README.md
	done
	popd || die
}
