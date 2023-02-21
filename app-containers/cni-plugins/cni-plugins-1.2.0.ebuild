# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module linux-info systemd

DESCRIPTION="Standard networking plugins for container networking"
HOMEPAGE="https://github.com/containernetworking/plugins"
SRC_URI="https://github.com/containernetworking/plugins/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"
IUSE="hardened"

RDEPEND="net-firewall/iptables"

CONFIG_CHECK="~BRIDGE_VLAN_FILTERING ~NETFILTER_XT_MATCH_COMMENT
	~NETFILTER_XT_MATCH_MULTIPORT"

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
	systemd_dounit plugins/ipam/dhcp/systemd/cni-dhcp.{service,socket}
	newinitd "${FILESDIR}"/cni-dhcp.initd cni-dhcp
}
