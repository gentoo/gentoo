# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake unpacker

DESCRIPTION="Fcitx5 Next generation of fcitx"
HOMEPAGE="https://fcitx-im.org/"
SRC_URI="https://download.fcitx-im.org/fcitx5/libime/libime-${PV}_dict.tar.zst"

LICENSE="LGPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv x86"
IUSE="+data doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-i18n/fcitx-5.1.13:5
	app-arch/zstd:=
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		dev-texlive/texlive-fontutils
	)
"

src_configure() {
	# 957570 : remove unused kenlm CMakeLists.txt
	rm src/libime/core/kenlm/CMakeLists.txt || die

	local mycmakeargs=(
		-DENABLE_DATA=$(usex data)
		-DENABLE_DOC=$(usex doc)
		-DENABLE_TEST=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install
	use doc && dodoc -r "${BUILD_DIR}"/doc/*
}
