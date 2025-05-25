# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info systemd

DESCRIPTION="Standard networking plugins for container networking"
HOMEPAGE="https://github.com/containernetworking/plugins"
SRC_URI="https://github.com/containernetworking/plugins/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/plugins-${PV}

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv"
IUSE="hardened"

RDEPEND="net-firewall/iptables"

CONFIG_CHECK="~BRIDGE_VLAN_FILTERING ~NETFILTER_XT_MATCH_COMMENT
	~NETFILTER_XT_MATCH_MULTIPORT"

src_compile() {
	local -x CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')"
	local f
	for f in plugins/{meta,main,ipam}/*; do
		[[ ${f} == *windows* ]] && continue
		einfo "Building ${f}"
		ego build -mod=vendor -o "bin/${f##*/}" "./${f}"
	done
}

src_install() {
	exeinto /opt/cni/bin
	doexe bin/*

	dodoc README.md
	local f
	for f in plugins/{meta,main,ipam}/*/README.md; do
		[[ ${f} == *windows* ]] && continue
		f=${f%/*}
		newdoc "${f}/README.md" "${f##*/}.README.md"
	done

	systemd_dounit plugins/ipam/dhcp/systemd/cni-dhcp.{service,socket}
	newinitd "${FILESDIR}"/cni-dhcp.initd cni-dhcp
}
