# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Library for Bible reading software"
HOMEPAGE="https://www.crosswire.org/sword/"
SRC_URI="https://www.crosswire.org/ftpmirror/pub/${PN}/source/v${PV%.*}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~ppc-macos"
IUSE="clucene curl debug doc icu"

RDEPEND="sys-libs/zlib
	curl? ( net-misc/curl )
	icu? ( dev-libs/icu:= )
	clucene? ( dev-cpp/clucene )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS CODINGSTYLE ChangeLog README )

src_configure() {
	use doc && DOCS+=( examples/ samples/ )

	# Upstream default is to build both the shared and the static library,
	# make sure we only build the shared one.
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}/etc"
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DLIBSWORD_LIBRARY_TYPE="Shared"
		-DWITH_CLUCENE=$(usex clucene)
		-DWITH_CURL=$(usex curl)
		-DWITH_ICU=$(usex icu)
		-DWITH_ZLIB=1
	)

	cmake_src_configure
}
