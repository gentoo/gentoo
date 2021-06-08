# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.code.sf.net/p/libwpd/libodfgen"
	inherit autotools git-r3
else
	SRC_URI="mirror://sourceforge/libwpd/${P}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~ppc64 x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Library to generate ODF documents from libwpd and libwpg"
HOMEPAGE="http://libwpd.sourceforge.net/"

LICENSE="|| ( LGPL-2.1 MPL-2.0 )"
SLOT="0"
IUSE="doc"

RDEPEND="
	dev-libs/librevenge
	dev-libs/libxml2:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_with doc docs)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
