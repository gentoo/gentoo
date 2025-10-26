# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5-chinese-addons"
inherit cmake unpacker xdg

DESCRIPTION="Addons related to Chinese, including IME previous bundled inside fcitx4"
HOMEPAGE="https://github.com/fcitx/fcitx5-chinese-addons"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}_dict.tar.zst"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2+ LGPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="+cloudpinyin +data +gui lua +opencc test webengine"
REQUIRED_USE="webengine? ( gui )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-i18n/fcitx-5.1.13:5
	>=app-i18n/libime-1.1.11:5[data?]
	>=dev-libs/boost-1.61:=
	cloudpinyin? ( net-misc/curl )
	gui? (
		>=app-i18n/fcitx-qt-5.1.4:5[qt6(+),-onlyplugin]
		dev-qt/qtbase:6[concurrent,gui,network,widgets]
		webengine? ( dev-qt/qtwebengine:6[widgets] )
	)
	lua? ( app-i18n/fcitx-lua:5 )
	opencc? ( app-i18n/opencc:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_BROWSER=$(usex webengine)
		-DENABLE_CLOUDPINYIN=$(usex cloudpinyin)
		-DENABLE_DATA=$(usex data)
		-DENABLE_GUI=$(usex gui)
		-DENABLE_OPENCC=$(usex opencc)
		-DENABLE_TEST=$(usex test)
	)
	cmake_src_configure
}
