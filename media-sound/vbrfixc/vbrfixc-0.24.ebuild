# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Vbrfix fixes MP3s and re-constructs VBR headers"
HOMEPAGE="http://home.gna.org/vbrfix/"
SRC_URI="ftp://mirror.bytemark.co.uk/gentoo/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# bin endian ones need vbrfixc-0.24-bigendian.diff from gentoo-x86 cvs Attic
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}/${P}-gcc43.patch" )

src_install() {
	HTML_DOCS=( vbrfixc/docs/en/*.html )
	default
}
