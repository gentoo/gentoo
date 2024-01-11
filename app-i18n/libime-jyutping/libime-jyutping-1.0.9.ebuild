# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A library make use of libime to implement jyutping input method"
HOMEPAGE="https://github.com/fcitx/libime-jyutping"
SRC_URI="https://download.fcitx-im.org/fcitx5/${PN}/${P}_dict.tar.xz -> ${P}.tar.xz"

LICENSE="LGPL-2.1+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +engine test"
RESTRICT="!test? ( test )"

DEPEND="
	>=app-i18n/libime-1.1.3:5
	app-arch/zstd
	>=dev-libs/boost-1.61
	dev-libs/libfmt
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-fontutils
	)
	engine? (
		app-i18n/fcitx:5
		app-i18n/fcitx-chinese-addons:5
		sys-devel/gettext
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
       "${FILESDIR}/${P}-add-missing-files-for-doc.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_ENGINE=$(usex engine)
		-DENABLE_TEST=$(usex test)
		-DENABLE_DOC=$(usex doc)
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
