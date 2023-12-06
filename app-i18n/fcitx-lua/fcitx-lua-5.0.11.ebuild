# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{3,4} )

MY_PN="fcitx5-lua"

inherit cmake lua-single xdg

DESCRIPTION="Lua support for fcitx"
HOMEPAGE="https://github.com/fcitx/fcitx5-lua"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="+dlopen test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${LUA_DEPS}
	app-i18n/fcitx:5
"
DEPEND="${RDEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	sys-devel/gettext
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	lua-single_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DUSE_DLOPEN=$(usex dlopen)
		-DENABLE_TEST=$(usex test)
	)
	cmake_src_configure
}
