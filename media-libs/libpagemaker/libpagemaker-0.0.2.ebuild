# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libpagemaker/libpagemaker-0.0.2.ebuild,v 1.5 2015/04/09 07:22:09 ago Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="C++ Library that parses the file format of Aldus/Adobe PageMaker documents."
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/${PN}"
SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug doc tools static-libs"

RDEPEND="
	dev-libs/librevenge
	"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.47
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	# fix Oops (commit 585b795c1431fd42d29391d1932bb6745edc2eb1)
	# remove in >=0.0.3
	sed \
		-e "s:no-undefines:no-undefined:g" \
		-i src/lib/Makefile.am || die

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--disable-werror
		$(use_enable tools)
		$(use_with doc docs)
		)
	autotools-utils_src_configure
}
