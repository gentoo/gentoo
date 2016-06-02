# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils

MY_P="ZThread-${PV}"

DESCRIPTION="platform-independent multi-threading and synchronization library for C++"
HOMEPAGE="http://zthread.sourceforge.net/"
SRC_URI="mirror://sourceforge/zthread/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="debug doc kernel_linux static-libs"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

PATCHES=(
    "${FILESDIR}"/${P}-no-fpermissive-r1.diff
    "${FILESDIR}"/${P}-m4-quote.patch
    "${FILESDIR}"/${P}-automake-r2.patch
    "${FILESDIR}"/${P}-gcc47.patch
    "${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	default

	rm -f include/zthread/{.Barrier.h.swp,Barrier.h.orig} || die

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die #467778

	AT_M4DIR="share" eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable kernel_linux atomic-linux) \
		$(use_enable static-libs static)
}

src_compile() {
	default

	if use doc; then
		doxygen doc/zthread.doxygen || die
		sed -i -e 's|href="html/|href="|' doc/documentation.html || die
		cp doc/documentation.html doc/html/index.html || die
		cp doc/{zthread.css,bugs.js} doc/html/ || die
	fi
}

src_install() {
	default

	use doc && dodoc -r doc/html

	prune_libtool_files
}
