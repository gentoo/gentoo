# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit linux-mod

DESCRIPTION="Simple yet fast and modern VPN that utilizes state-of-the-art cryptography."
HOMEPAGE="https://www.wireguard.io/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.zx2c4.com/WireGuard"
	KEYWORDS=""
else
	SRC_URI="https://git.zx2c4.com/WireGuard/snapshot/experimental/${PV}.tar.xz -> ${P}.tar.xz"
	S="${WORKDIR}/experimental/${PV}"
	KEYWORDS="~amd64 ~x86 ~mips ~arm ~arm64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="net-libs/libmnl"
RDEPEND="${DEPEND}"

MODULE_NAMES="wireguard(net:src)"
BUILD_PARAMS="KERNELDIR=${KERNEL_DIR} V=1"
CONFIG_CHECK="NET_UDP_TUNNEL IPV6 NETFILTER_XT_MATCH_HASHLIMIT ~PADATA"
ERROR_NET_UDP_TUNNEL="WireGuard requires NET_UDP_TUNNEL."
ERROR_IPV6="WireGuard requires IPV6 support in the kernel."
ERROR_NETFILTER_XT_MATCH_HASHLIMIT="WireGuard requires NETFILTER_XT_MATCH_HASHLIMIT."
ERROR_PADATA="If you're running a multicore system you likely should enable CONFIG_PADATA for improved performance and parallel crypto."

pkg_setup() {
	linux-mod_pkg_setup
	kernel_is -lt 4 1 0 && die "This version of ${PN} requires Linux >= 4.1"
}

src_prepare() {
	default
	sed -i 's/install -s/install/' src/tools/Makefile
}

src_compile() {
	linux-mod_src_compile
	emake -C src/tools
}

src_install() {
	dodoc README.md
	linux-mod_src_install
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" -C src/tools install
}

pkg_postinst() {
	linux-mod_pkg_postinst
	ewarn
	ewarn "This software is experimental and has not yet been released."
	ewarn "As such, it may contain significant issues. Please do not file"
	ewarn "bug reports with Gentoo, but rather direct them upstream to:"
	ewarn
	ewarn "    team@wireguard.io    security@wireguard.io"
	ewarn
}
