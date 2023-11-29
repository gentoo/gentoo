# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A high-level decoding and seeking API for .opus files"
HOMEPAGE="https://www.opus-codec.org/"
SRC_URI="https://downloads.xiph.org/releases/opus/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv sparc x86"
IUSE="doc fixed-point +float +http static-libs"

RDEPEND="
	media-libs/libogg
	media-libs/opus
	http? (
		dev-libs/openssl:=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

REQUIRED_USE="^^ ( fixed-point float )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.12-configure-clang16.patch
)

src_prepare() {
	default

	# Drop once configure patch merged
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc)
		$(use_enable fixed-point)\
		$(use_enable float)
		$(use_enable http)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}
