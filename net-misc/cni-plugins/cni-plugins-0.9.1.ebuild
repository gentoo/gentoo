# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module linux-info

DESCRIPTION="Standard networking plugins for container networking"
HOMEPAGE="https://github.com/containernetworking/plugins"
SRC_URI="https://github.com/containernetworking/plugins/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64"
IUSE="hardened"

CONFIG_CHECK="~BRIDGE_VLAN_FILTERING"
S="${WORKDIR}/plugins-${PV}"

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" ./build_linux.sh || die
}

src_install() {
	exeinto /opt/cni/bin
	doexe bin/*
	dodoc README.md
	local i
	for i in plugins/{meta/{bandwidth,firewall,flannel,portmap,sbr,tuning},main/{bridge,host-device,ipvlan,loopback,macvlan,ptp,vlan},ipam/{dhcp,host-local,static},sample}; do
		newdoc README.md ${i##*/}.README.md
	done
	newinitd "${FILESDIR}"/cni-dhcp.initd cni-dhcp
}
