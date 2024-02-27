# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5-chinese-addons"

inherit cmake xdg

DESCRIPTION="Addons related to Chinese, including IME previous bundled inside fcitx4."
HOMEPAGE="https://github.com/fcitx/fcitx5-chinese-addons"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}_dict.tar.xz"

LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
SLOT="5"
IUSE="+data +gui webengine +cloudpinyin +qt5 qt6 lua +opencc test"
REQUIRED_USE="
	webengine? ( gui )
"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-i18n/fcitx-5.1.6:5
	>=app-i18n/libime-1.1.3:5[data?]
	>=dev-libs/boost-1.61:=
	cloudpinyin? ( net-misc/curl )
	lua? ( app-i18n/fcitx-lua:5 )
	opencc? ( app-i18n/opencc:= )
	gui? (
		qt5? (
			dev-qt/qtconcurrent:5
			app-i18n/fcitx-qt:5[qt5,-onlyplugin]
			webengine? ( dev-qt/qtwebengine:5[widgets] )
		)
		qt6? (
			dev-qt/qtbase:6[concurrent]
			app-i18n/fcitx-qt:5[qt6,-onlyplugin]
			webengine? ( dev-qt/qtwebengine:6[widgets] )
		)
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_BROWSER=$(usex webengine)
		-DENABLE_CLOUDPINYIN=$(usex cloudpinyin)
		-DENABLE_DATA=$(usex data)
		-DENABLE_GUI=$(usex gui)
		-DENABLE_OPENCC=$(usex opencc)
		-DENABLE_TEST=$(usex test)
		-DUSE_WEBKIT=no
		-DUSE_QT6=$(usex qt6)
	)
	cmake_src_configure
}
