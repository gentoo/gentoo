# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://git.libreoffice.org/libzmf"
	inherit git-r3 autotools
else
	SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Library for parsing Zoner Callisto/Draw documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libzmf"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="debug doc test tools"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/icu:=
	dev-libs/librevenge
	media-libs/libpng:0=
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
	test? ( dev-util/cppunit )
"
BDEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-werror
		$(use_enable debug)
		$(use_with doc docs)
		$(use_enable test tests)
		$(use_enable tools)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
