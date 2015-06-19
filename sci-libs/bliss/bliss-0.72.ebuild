# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/bliss/bliss-0.72.ebuild,v 1.2 2015/04/03 13:11:35 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

SRC_URI="http://www.tcs.hut.fi/Software/${PN}/${P}.zip"
DESCRIPTION="A Tool for Computing Automorphism Groups and Canonical Labelings of Graphs"
HOMEPAGE="http://www.tcs.hut.fi/Software/bliss/index.shtml"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gmp static-libs"

RDEPEND="gmp? ( dev-libs/gmp:0= )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

AUTOTOOLS_PRUNE_LIBTOOL_FILES="all" #comes with pkg-config file

PATCHES=(
	"${FILESDIR}/${P}-fedora.patch"
	"${FILESDIR}/${P}-autotools.patch"
)

src_configure() {
	local myeconfargs=( $(use_with gmp) )
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile all $(usex doc html "")
}

src_install() {
	use doc && HTML_DOCS=( "${BUILD_DIR}"/html/. )
	autotools-utils_src_install
}
