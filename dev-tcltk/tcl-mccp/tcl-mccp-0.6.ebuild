# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="mccp extension to TCL"
HOMEPAGE="http://tcl-mccp.sf.net/"
SRC_URI="mirror://sourceforge/tcl-mccp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="static-libs"

DEPEND="dev-lang/tcl:0="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-flags.patch )

src_configure() {
	econf --with-tcl="${EPREFIX}"/usr/$(get_libdir)
}
