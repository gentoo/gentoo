# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A crossplatform TCL/TK based MUD client"
HOMEPAGE="http://belfry.com/fuzzball/trebuchet/"
SRC_URI="mirror://sourceforge/trebuchet/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
RESTRICT="test"

RDEPEND="
	dev-lang/tcl:0=
	>=dev-lang/tk-8.3.3:0=
"

src_prepare() {
	default

	sed -i \
		-e "/Nothing/d" \
        -e "/LN/ s:../libexec:/usr/share:" \
		Makefile || die
}

src_install() {
	emake prefix="${D}/usr" \
		ROOT="${D}/usr/share/${PN}" install

	insinto /usr/share/${PN}
	doins COPYING
	dodoc changes.txt readme.txt trebtodo.txt
}
