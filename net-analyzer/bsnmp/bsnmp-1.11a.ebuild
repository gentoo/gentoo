# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils flag-o-matic

DESCRIPTION="Mini-SNMP Daemon and Library"
HOMEPAGE="http://people.freebsd.org/~harti/"
SRC_URI="http://people.freebsd.org/~harti/bsnmp/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86-fbsd"
IUSE="tcpd"

DEPEND="dev-libs/libbegemot
	tcpd? ( sys-apps/tcp-wrappers )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-1.10-gcc34.patch"
}

src_compile() {
	if use elibc_glibc; then
		# bsnmp is bsd-based, without this it will fail
		append-flags "-D_BSD_SOURCE"
	fi

	filter-flags -fno-inline

	econf \
		--with-libbegemot=/usr \
		$(use_with tcpd tcpwrappers) \
		|| die "econf failed"

	emake -j1 || die "emake failed"
}

src_install() {
	einstall || die "make install failed"
}
