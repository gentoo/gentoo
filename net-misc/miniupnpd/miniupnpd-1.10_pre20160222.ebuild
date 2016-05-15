# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs versionator flag-o-matic

MY_PV=$(get_version_component_range 3)
MY_PV=1.9.${MY_PV#pre}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="MiniUPnP IGD Daemon"
HOMEPAGE="http://miniupnp.free.fr/"
SRC_URI="http://miniupnp.free.fr/files/${MY_P}.tar.gz"

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

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-1.10_pre20160222-build.patch"
)

src_prepare() {
	default
	mv Makefile.linux Makefile || die
}

src_configure() {
	local -a opts
	opts=(
		--vendorcfg
		$(use igd2 && printf -- '--igd2\n')
		$(use ipv6 && printf -- '--ipv6\n')
		$(use leasefile && printf -- '--leasefile\n')
		$(use portinuse && printf -- '--portinuse\n')
		$(use pcp-peer && printf -- '--pcp-peer\n')
		$(use strict && printf -- '--strict\n')
	)

	emake CONFIG_OPTIONS="${opts[*]}" config.h
}

src_compile() {
	# By default, it builds a bunch of unittests that are missing wrapper
	# scripts in the tarball
	emake CC="$(tc-getCC)" \
		STRIP=true \
		LDLIBS_IPV6="$(use ipv6 && printf -- '-lip6tc')" \
		miniupnpd
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
