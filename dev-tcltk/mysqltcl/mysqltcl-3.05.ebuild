# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/mysqltcl/mysqltcl-3.05.ebuild,v 1.8 2015/03/20 10:34:57 jlec Exp $

EAPI=4

inherit eutils multilib

DESCRIPTION="TCL MySQL Interface"
HOMEPAGE="http://www.xdobry.de/mysqltcl/"
SRC_URI="http://www.xdobry.de/mysqltcl/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND="
	dev-lang/tcl:0
	>=virtual/mysql-4.1"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
	sed -i 's/-pipe//g;s/-O2//g;s/-fomit-frame-pointer//g' configure || die
}

src_configure() {
	econf --with-mysql-lib=/usr/$(get_libdir)/mysql
}

src_install() {
	default
	dohtml doc/mysqltcl.html
}
