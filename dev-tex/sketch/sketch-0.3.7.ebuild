# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/sketch/sketch-0.3.7.ebuild,v 1.1 2012/03/01 11:50:51 aballier Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Produces drawings of two- or three-dimensional solid objects and scenes for TeX"
HOMEPAGE="http://www.frontiernet.net/~eugene.ressler/"
SRC_URI="http://www.frontiernet.net/~eugene.ressler/${P}.tgz"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="doc examples"

DEPEND="dev-lang/perl"
RDEPEND=""

src_unpack() {
	unpack ${A}

	cd "${S}"
	sed -i -e "s:\$(CC):\$(CC) \$(LDFLAGS):" makefile
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	dobin sketch || die
	edos2unix Doc/sketch.info
	doinfo Doc/sketch.info || die
	dohtml updates.htm || die
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins Doc/sketch.pdf || die
		dohtml Doc/sketch/* || die
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins Data/* || die "Failed to install examples"
	fi
}
