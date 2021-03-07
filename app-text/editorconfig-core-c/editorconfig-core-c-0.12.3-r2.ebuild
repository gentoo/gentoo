# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="EditorConfig core library written in C"
HOMEPAGE="https://github.com/editorconfig/editorconfig-core-c/"
SRC_URI="https://github.com/editorconfig/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE="cli doc"

BDEPEND="doc? ( app-doc/doxygen )"
DEPEND="dev-libs/libpcre2:="
RDEPEND="${DEPEND}
	cli? ( !dev-python/editorconfig-core-py[cli] )"

PATCHES=( "${FILESDIR}/${P}-no-static-libs.patch" )

src_configure() {
	local -a mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc 'ON' 'OFF')
	)
	cmake_src_configure
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	cmake_src_install

	if ! use cli; then
		rm -r "${ED}/usr/bin" || die
	fi
}
