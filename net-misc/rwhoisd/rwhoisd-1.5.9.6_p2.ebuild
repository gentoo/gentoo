# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_PV="${PV%%_p*}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="ARIN rwhois daemon"
HOMEPAGE="https://projects.arin.net/rwhois/"
SRC_URI="
	https://github.com/arineng/${PN}/archive/${MY_PV}.tar.gz
		-> ${MY_P}.tar.gz
	https://dev.gentoo.org/~arkamar/distfiles/${MY_P}-patches-${PV##*_p}.tar.xz
"
S="${WORKDIR}/${MY_P}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-apps/tcp-wrappers
	virtual/libcrypt:=
"
RDEPEND="
	${DEPEND}
	acct-group/rwhoisd
	acct-user/rwhoisd
"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
"

PATCHES=( "${WORKDIR}"/patches )

src_prepare() {
	default
	eautoreconf #893906
}

src_compile() {
	append-cflags -DNEW_STYLE_BIN_SORT -std=gnu89

	default
}

src_install() {
	default

	doinitd "${FILESDIR}"/rwhoisd
	newconfd "${FILESDIR}"/rwhoisd.conf rwhoisd
}

pkg_postinst() {
	einfo "Please make sure to set the userid in rwhoisd.conf to rwhoisd."
	einfo "It is highly inadvisable to run rwhoisd as root."
}
