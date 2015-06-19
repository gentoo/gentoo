# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/libabw/libabw-0.0.2.ebuild,v 1.3 2014/06/29 16:43:34 ago Exp $

EAPI=5

inherit base eutils

DESCRIPTION="Library parsing abiword documents"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/libabw/"
SRC_URI="http://dev-www.libreoffice.org/src//${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="doc static-libs"

RDEPEND="
	app-text/libwpd:0.9
	dev-libs/libxml2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.46
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--disable-werror \
		$(use_enable static-libs static) \
		$(use_with doc docs)
}

src_install() {
	default
	prune_libtool_files --all
}
