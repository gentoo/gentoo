# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="A general purpose library for the OpenWrt project."
HOMEPAGE="https://git.openwrt.org/?p=project/libubox.git;a=summary"
EGIT_REPO_URI="https://git.openwrt.org/project/libubox.git"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="lua"

REPEND="lua? ( >=dev-lang/lua-5.1:0 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	sed -i 's|\<json/json.h\>|json-c/json.h|' jshn.c blobmsg_json.h
	echo 'INCLUDE_DIRECTORIES(/usr/include/libnl3)' >> CMakeLists.txt

	# Do not violate multilib-strict check
	sed -e "s/DESTINATION lib/DESTINATION $(get_libdir)/" -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_LUA=$(usex lua)
		-DBUILD_EXAMPLES=OFF
	)

	cmake_src_configure
}
