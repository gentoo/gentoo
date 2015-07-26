# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/libmwaw/libmwaw-0.3.5.ebuild,v 1.3 2015/07/22 19:33:29 ago Exp $

EAPI=5

inherit base eutils

DESCRIPTION="Library parsing many pre-OSX MAC text formats"
HOMEPAGE="http://sourceforge.net/p/libmwaw/wiki/Home/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="doc static-libs"

RDEPEND="
	dev-libs/librevenge
	dev-libs/libxml2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.46:=
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	# zip is hard enabled as the zlib is dep on the rdeps anyway
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--with-sharedptr=boost \
		--enable-zip \
		--disable-werror \
		$(use_enable static-libs static) \
		$(use_with doc docs)
}

src_install() {
	default
	prune_libtool_files --all
}
