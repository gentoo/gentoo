# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MDDS_VER="2.1"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/libreoffice/libetonyek.git"
	inherit autotools git-r3
else
	SRC_URI="https://dev-www.libreoffice.org/src/libetonyek/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Library parsing Apple Keynote presentations"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"

LICENSE="|| ( GPL-2+ LGPL-2.1 MPL-1.1 )"
SLOT="0"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-text/liblangtag
	dev-libs/librevenge
	dev-libs/libxml2
	dev-util/mdds:1/${MDDS_VER}
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
	media-libs/glm
	sys-devel/libtool
	test? ( dev-util/cppunit )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	default
	[[ -d m4 ]] || mkdir "m4"
	[[ ${PV} == *9999* ]] && eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-werror
		--with-mdds="${MDDS_VER}"
		$(use_with doc docs)
		$(use_enable static-libs static)
		$(use_enable test tests)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
