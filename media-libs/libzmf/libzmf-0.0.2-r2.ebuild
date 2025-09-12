# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.libreoffice.org/libzmf"
	inherit git-r3
else
	SRC_URI="https://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi
inherit autotools

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
BDEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}/${P}-fix-doc-install.patch" # bug 961617
	"${FILESDIR}/${P}-fix-configure-warning.patch"
	"${FILESDIR}/${P}-fix-too-small-loop-vars.patch"
)

src_prepare() {
	default
	eautoreconf
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
