# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="EditorConfig core library written in C"
HOMEPAGE="https://github.com/editorconfig/editorconfig-core-c/"
SRC_URI="https://github.com/editorconfig/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="cli doc"

BDEPEND="doc? ( app-text/doxygen )"
DEPEND="dev-libs/libpcre2:="
RDEPEND="
	${DEPEND}
	cli? ( !dev-python/editorconfig[cli] !<dev-python/editorconfig-editorconfig-0.12.4-r1 )
"
# Header-only
DEPEND+=" dev-libs/uthash"

src_prepare() {
	# Don't install the static library.
	sed -e '/install(TARGETS editorconfig_static/,+5d' -i src/lib/CMakeLists.txt || die

	# Unbundle dev-libs/uthash
	rm src/lib/utarray.h || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc 'ON' 'OFF')
		-DBUILD_STATICALLY_LINKED_EXE=OFF
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
