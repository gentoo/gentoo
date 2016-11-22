# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="A GNU Netlist Manipulation Library"
HOMEPAGE="https://sourceforge.net/projects/gnetman/"
#snapshot from http://gnetman.git.sourceforge.net/git/gitweb.cgi?p=gnetman/gnetman;
SRC_URI="mirror://gentoo/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
IUSE="doc examples"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${P}/src/batch

RDEPEND="dev-lang/tcl:0
	sci-electronics/geda"
DEPEND="${RDEPEND}
	dev-db/datadraw"

src_prepare() {
	sed -e "/^CFLAGS=/s:-g -Wall:${CFLAGS}:" \
	    -e "/^CFLAGS=/s:-I/usr/include/tcl8.4::" \
		-e "/^LIBS=/s:-ltcl8.4:-ltcl:" \
		-e '/^$(TARGET):/,+3s:$(CFLAGS):$(CFLAGS) $(LDFLAGS):' \
		-i configure || die
	tc-export CC

	cd ../.. || die
	# fix build issues with tcl-8.6, #452034
	epatch "${FILESDIR}/${P}-tcl86.patch"
}

src_install () {
	cd ../.. || die

	dobin bin/${PN}

	insinto /usr/share/gEDA
	doins system-gnetmanrc.tcl

	use examples && dodoc -r sym sch test
	dodoc README
	use doc && dodoc doc/*.{html,jpg}
}
