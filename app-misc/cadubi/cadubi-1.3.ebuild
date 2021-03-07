# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An application that allows you to draw ASCII-Art images"
HOMEPAGE="http://langworth.com/CadubiProject"
SRC_URI="http://langworth.com/downloads/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86"
IUSE=""

DEPEND="dev-lang/perl
	>=dev-perl/TermReadKey-2.21"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-helpfile.patch
}

src_install() {
	dobin cadubi
	insinto /usr/$(get_libdir)/${PN}
	doins help.txt
	dodoc README
}
