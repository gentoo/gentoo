# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://anongit.freedesktop.org/git/libreoffice/libetonyek.git"
[[ ${PV} == 9999 ]] && inherit git-r3
inherit autotools

DESCRIPTION="Library parsing Apple Keynote presentations"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
[[ ${PV} == 9999 ]] || SRC_URI="https://dev-www.libreoffice.org/src/libetonyek/${P}.tar.xz"

LICENSE="|| ( GPL-2+ LGPL-2.1 MPL-1.1 )"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="doc static-libs test"

RDEPEND="
	app-text/liblangtag
	dev-libs/librevenge
	dev-libs/libxml2
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}
	dev-libs/boost
	>=dev-util/mdds-1.2.2:1
	media-libs/glm
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"

PATCHES=( "${FILESDIR}/${P}-glm-0.9.9.patch" )

src_prepare() {
	default
	[[ -d m4 ]] || mkdir "m4"
	eautoreconf
}

src_configure() {
	econf \
		--disable-werror \
		$(use_with doc docs) \
		$(use_enable static-libs static) \
		$(use_enable test tests) \
		--with-mdds=1.2
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
