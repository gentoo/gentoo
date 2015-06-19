# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/libebook/libebook-0.0.2.ebuild,v 1.4 2014/06/29 16:43:40 ago Exp $

EAPI=5

MY_PN="libe-book"
MY_P="${MY_PN}-${PV}"

inherit eutils

DESCRIPTION="Library parsing various ebook formats"
HOMEPAGE="http://www.sourceforge.net/projects/libebook/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="|| ( LGPL-2.1 MPL-2.0 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="doc test"

RDEPEND="
	>=app-text/libwpd-0.9.5:0.9
	dev-libs/icu:=
	dev-libs/libxml2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost:=
	dev-util/gperf
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--disable-static \
		--disable-werror \
		$(use_with doc docs) \
		$(use_enable test tests) \
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_install() {
	default
	prune_libtool_files --all
}
