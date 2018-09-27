# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_PN="${PN/lib/}"

inherit cmake-utils toolchain-funcs

DESCRIPTION="A C library that provides various operations for data in the UTF-8 encoding"
HOMEPAGE="https://juliastrings.github.io/utf8proc/"
SRC_URI="https://github.com/JuliaStrings/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# Tests do need internet access
RESTRICT="test"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=( "${FILESDIR}/${P}-fix-path.patch" )

src_prepare() {
	tc-export AR CC

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
	)

	cmake-utils_src_configure
}

src_test() {
	emake check
}

src_install() {
	emake LIBDIR_GENTOO="$(get_libdir)" PREFIX_GENTOO="${ED%/}" install

	dodoc lump.md NEWS.md README.md
}
