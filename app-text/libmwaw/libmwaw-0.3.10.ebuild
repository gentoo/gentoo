# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="git://git.code.sf.net/p/libmwaw/libmwaw"
[[ ${PV} == 9999 ]] && inherit autotools git-r3

DESCRIPTION="Library parsing many pre-OSX MAC text formats"
HOMEPAGE="https://sourceforge.net/p/libmwaw/wiki/Home/"
[[ ${PV} == 9999 ]] || SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"

[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~x86"

IUSE="doc static-libs tools"

RDEPEND="
	dev-libs/librevenge
	dev-libs/libxml2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	# zip is hard enabled as the zlib is dep on the rdeps anyway
	econf \
		--enable-zip \
		--disable-werror \
		--with-sharedptr=c++11 \
		$(use_with doc docs) \
		$(use_enable static-libs static) \
		$(use_enable tools)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
