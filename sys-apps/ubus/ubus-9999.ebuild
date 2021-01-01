# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="An embedded bus system developed for OpenWrt. It is like dbus but simple and small."
HOMEPAGE="https://git.openwrt.org/?p=project/ubus.git;a=summary"
EGIT_REPO_URI="https://git.openwrt.org/project/ubus.git"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="lua"

RDEPEND="
	dev-libs/libubox
	lua? ( >=dev-lang/lua-5.1:0 )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# Do not violate multilib-strict check
	sed -e "s/DESTINATION lib/DESTINATION $(get_libdir)/" -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_LUA=$(usex lua)
	)

	cmake_src_configure
}
