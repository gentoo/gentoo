# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib

DESCRIPTION="CADUBI is an application that allows you to draw ASCII-Art images"
HOMEPAGE="http://langworth.com/CadubiProject"
SRC_URI="http://langworth.com/downloads/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86"
IUSE=""

DEPEND="dev-lang/perl
	>=dev-perl/TermReadKey-2.21"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-helpfile.patch
}

src_install() {
	dobin cadubi || die
	insinto /usr/$(get_libdir)/${PN}
	doins help.txt
	dodoc README
}
