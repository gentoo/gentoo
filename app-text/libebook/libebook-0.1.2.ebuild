# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="libe-book"
MY_P="${MY_PN}-${PV}"

inherit eutils

DESCRIPTION="Library parsing various ebook formats"
HOMEPAGE="http://www.sourceforge.net/projects/libebook/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="doc test"

RDEPEND="
	dev-libs/icu:=
	dev-libs/librevenge
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
