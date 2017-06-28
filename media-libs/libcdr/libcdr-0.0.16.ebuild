# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGIT_REPO_URI="git://anongit.freedesktop.org/git/libreoffice/libcdr/"
inherit base eutils

DESCRIPTION="Library parsing the Corel cdr documents"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libcdr"
SRC_URI="http://dev-www.libreoffice.org/src/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~ppc"
IUSE="doc static-libs"

RDEPEND="
	app-text/libwpd:0.9
	app-text/libwpg:0.2
	dev-libs/icu:=
	media-libs/lcms:2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	base_src_prepare
	[[ -d m4 ]] || mkdir "m4"
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable static-libs static) \
		--disable-werror \
		$(use_with doc docs)
}

src_install() {
	default
	prune_libtool_files --all
}
