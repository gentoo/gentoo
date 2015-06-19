# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/libmwaw/libmwaw-0.1.10.ebuild,v 1.4 2013/11/09 17:21:57 dilfridge Exp $

EAPI=5

inherit base eutils

DESCRIPTION="Library parsing many pre-OSX MAC text formats"
HOMEPAGE="http://sourceforge.net/p/libmwaw/wiki/Home/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="doc static-libs"

RDEPEND="
	>=app-text/libwpd-0.9.5:0.9
	app-text/libwpg:0.2
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
