# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="A fast WebAssembly interpreter and the most universal WASM runtime"
HOMEPAGE="https://github.com/wasm3/wasm3/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

PATCHES=( "${FILESDIR}/wasm3-0.5.0-cmake_minimum.patch" )

DOCS=( README.md docs )

src_configure() {
	# bug https://bugs.gentoo.org/925933
	filter-lto
	append-flags -fno-strict-aliasing

	local -a mycmakeargs=(
		-DBUILD_WASI=simple
	)

	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/wasm3"

	einstalldocs
}
