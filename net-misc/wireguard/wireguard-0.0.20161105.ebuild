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
	SRC_URI="https://git.zx2c4.com/WireGuard/snapshot/WireGuard-experimental-${PV}.tar.xz"
	S="${WORKDIR}/WireGuard-experimental-${PV}"
	KEYWORDS="~amd64 ~x86 ~mips ~arm ~arm64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug kmod-src"

DEPEND="net-libs/libmnl"
RDEPEND="${DEPEND}"

MODULE_NAMES="wireguard(net:src)"
BUILD_PARAMS="KERNELDIR=${KERNEL_DIR} V=1"
BUILD_TARGETS="module"
CONFIG_CHECK="NET INET NET_UDP_TUNNEL NF_CONNTRACK NETFILTER_XT_MATCH_HASHLIMIT CRYPTO_BLKCIPHER ~PADATA ~IP6_NF_IPTABLES"
WARNING_PADATA="If you're running a multicore system you likely should enable CONFIG_PADATA for improved performance and parallel crypto."
WARNING_IP6_NF_IPTABLES="If your kernel has CONFIG_IPV6, you need CONFIG_IP6_NF_IPTABLES; otherwise WireGuard will not insert."

pkg_setup() {
	use kmod-src && return
	linux-mod_pkg_setup
	kernel_is -lt 4 1 0 && die "This version of ${PN} requires Linux >= 4.1"
}

src_compile() {
	use debug && BUILD_PARAMS="CONFIG_WIREGUARD_DEBUG=y ${BUILD_PARAMS}"
	use kmod-src || linux-mod_src_compile
	emake RUNSTATEDIR="${EPREFIX}/run" -C src/tools
}

src_install() {
	dodoc README.md
	dodoc -r contrib/examples
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" -C src/tools install
	if use kmod-src; then
		dodir /usr/src
		rm -r "${S}"/src/tools || die
		mv -v "${S}"/src "${ED}"usr/src/wireguard || die
	else
		linux-mod_src_install
	fi
	insinto /$(get_libdir)/netifrc/net
	newins "${FILESDIR}"/wireguard-openrc.sh wireguard.sh
}

pkg_postinst() {
	if use kmod-src; then
		einfo
		einfo "You have enabled the kmod-src USE flag. This means that sources"
		einfo "are installed to ${ROOT}usr/src/wireguard instead of having the"
		einfo "kernel module compiled. You will need to compile the module"
		einfo "yourself. Most likely, you don't want this USE flag."
		einfo
	else
		linux-mod_pkg_postinst
	fi
	ewarn
	ewarn "This software is experimental and has not yet been released."
	ewarn "As such, it may contain significant issues. Please do not file"
	ewarn "bug reports with Gentoo, but rather direct them upstream to:"
	ewarn
	ewarn "    team@wireguard.io    security@wireguard.io"
	ewarn

	einfo
	einfo "After installing WireGuard, if you'd like to try sending some packets through"
	einfo "WireGuard, you may use, for testing purposes only, the insecure client.sh"
	einfo "test example script:"
	einfo
	einfo "  \$ bzcat ${ROOT}usr/share/doc/${PF}/examples/ncat-client-server/client.sh.bz2 | sudo bash -"
	einfo
	einfo "This will automatically setup interface wg0, through a very insecure transport"
	einfo "that is only suitable for demonstration purposes. You can then try loading the"
	einfo "hidden website or sending pings:"
	einfo
	einfo "  \$ chromium http://192.168.4.1"
	einfo "  \$ ping 192.168.4.1"
	einfo
	einfo "If you'd like to redirect your internet traffic, you can run it with the"
	einfo "\"default-route\" argument. You may not use this server for any abusive or illegal"
	einfo "purposes. It is for quick testing only."
	einfo
	einfo "More info on getting started can be found at: https://www.wireguard.io/quickstart/"
	einfo
}
