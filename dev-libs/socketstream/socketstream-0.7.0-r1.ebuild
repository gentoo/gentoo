# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C++ Streaming sockets library"
HOMEPAGE="http://socketstream.sourceforge.net/"
SRC_URI="mirror://sourceforge/socketstream/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~ppc ~sparc x86"
IUSE="doc"

BDEPEND="doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PV}-missing_includes.patch
	"${FILESDIR}"/${P}-gcc47.patch
)

src_prepare() {
	default
	# include/Makefile uses DIST_SUBDIRS and thus headers dont get installed
	sed -i 's|^DIST_\(SUBDIRS =\)|\1|' include/Makefile.in || \
		die "sed include/Makefile.in failed"
}

src_compile() {
	default
	use doc && emake doxygen
}

src_install() {
	use doc && local HTML_DOCS=( docs/html/. )
	default
}
