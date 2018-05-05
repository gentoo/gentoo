# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="MiniUPnP IGD Daemon"
HOMEPAGE="http://miniupnp.free.fr/"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+leasefile igd2 ipv6 pcp-peer portinuse strict"

RDEPEND=">=net-firewall/iptables-1.4.6:0=[ipv6?]
	net-libs/libnfnetlink:=
	net-libs/libmnl:=
	dev-libs/gmp:0=
	sys-apps/util-linux
	dev-libs/openssl:0="
DEPEND="${RDEPEND}
	sys-apps/lsb-release"

src_prepare() {
	default
	mv Makefile.linux Makefile || die
}

src_configure() {
	local -a opts
	opts=(
		--vendorcfg
		$(usex igd2 '--igd2' '')
		$(usex ipv6 '--ipv6' '')
		$(usex leasefile '--leasefile' '')
		$(usex portinuse '--portinuse' '')
		$(usex pcp-peer '--pcp-peer' '')
		$(usex strict '--strict' '')
	)

	emake CONFIG_OPTIONS="${opts[*]}" config.h
}

src_compile() {
	# By default, it builds a bunch of unittests that are missing wrapper
	# scripts in the tarball
	emake CC="$(tc-getCC)" STRIP=true miniupnpd
}

src_install() {
	emake PREFIX="${ED}" STRIP=true install

	newinitd "${FILESDIR}"/${PN}-init.d-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}-conf.d-r1 ${PN}
}

pkg_postinst() {
	elog "Please correct the external interface in the top of the two"
	elog "scripts in /etc/miniupnpd and edit the config file in there too"
}
