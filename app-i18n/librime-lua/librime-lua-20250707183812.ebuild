# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
LUA_COMPAT=( lua5-{1..4} luajit )

inherit cmake flag-o-matic lua-single

if [[ "${PV}" == "99999999999999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/hchunhui/librime-lua"
else
	LIBRIME_LUA_GIT_REVISION="68f9c364a2d25a04c7d4794981d7c796b05ab627"
fi

DESCRIPTION="Lua module for RIME"
HOMEPAGE="https://github.com/hchunhui/librime-lua"
if [[ "${PV}" != "99999999999999" ]]; then
	SRC_URI="https://github.com/hchunhui/${PN}/archive/${LIBRIME_LUA_GIT_REVISION}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND=">=app-i18n/librime-1.6:0=
	${LUA_DEPS}"
DEPEND="${RDEPEND}
	dev-libs/boost:0"

if [[ "${PV}" != "99999999999999" ]]; then
	S="${WORKDIR}/${PN}-${LIBRIME_LUA_GIT_REVISION}"
fi

src_prepare() {
	sed \
		-e "1icmake_minimum_required(VERSION 3.12)\nproject(${PN})\n" \
		-e "s/ PARENT_SCOPE//" \
		-e "\$a\\\n" \
		-e "\$aadd_library(\${plugin_modules} MODULE \${plugin_objs})" \
		-e "\$aset_target_properties(\${plugin_modules} PROPERTIES PREFIX \"\")" \
		-e "\$atarget_link_libraries(\${plugin_modules} rime \${plugin_deps})" \
		-e "\$ainstall(TARGETS \${plugin_modules} DESTINATION $(get_libdir)/rime-plugins)" \
		-i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# https://bugs.gentoo.org/966950
	append-flags -std=gnu++17
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/940793
	# https://github.com/hchunhui/librime-lua/issues/412
	append-flags -fno-strict-aliasing
	filter-lto

	cmake_src_configure
}
