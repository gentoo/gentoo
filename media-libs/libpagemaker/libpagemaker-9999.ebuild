# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://git.libreoffice.org/libpagemaker"
	inherit autotools git-r3
else
	SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi
DESCRIPTION="C++ Library that parses the file format of Aldus/Adobe PageMaker documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libpagemaker"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="debug doc tools"

RDEPEND="
	dev-libs/librevenge
"
DEPEND="${RDEPEND}
	dev-libs/boost
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-werror
		$(use_with doc docs)
		$(use_enable tools)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -type f -delete || die
}
