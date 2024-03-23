# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="ARIN rwhois daemon"
HOMEPAGE="http://projects.arin.net/rwhois/"
SRC_URI="https://github.com/arineng/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/libcrypt:="
RDEPEND="
	${DEPEND}
	acct-group/rwhoisd
	acct-user/rwhoisd
"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
"

src_compile() {
	append-cflags -DNEW_STYLE_BIN_SORT

	emake -C common
	emake -C regexp
	emake -C mkdb

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
