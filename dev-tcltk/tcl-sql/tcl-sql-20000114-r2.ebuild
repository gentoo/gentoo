# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tcl-sql/tcl-sql-20000114-r2.ebuild,v 1.4 2015/03/20 10:41:03 jlec Exp $

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="A generic Tcl interface to SQL databases"
HOMEPAGE="http://www.parand.com/tcl-sql/"
SRC_URI="mirror://sourceforge/tcl-sql/${PN}-${PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	dev-lang/tcl:0=
	virtual/mysql"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}

src_prepare() {
	find . -type f -exec chmod 644 '{}' \; || die
	epatch \
		"${FILESDIR}"/fix-const.patch \
		"${FILESDIR}"/ldflags.patch
	tc-export CXX
}

src_install() {
	exeinto /usr/$(get_libdir)/${P}
	doexe sql.so
	dodoc CHANGES.txt CODE_DESCRIPTION.txt docs/sample.full.txt docs/sample.simple.txt
	dohtml README.html docs/api.html
}
