# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua toolchain-funcs

DESCRIPTION="Stackable Continuation Queues"
HOMEPAGE="https://github.com/wahern/cqueues"
HOMEPAGE+=" http://25thandclement.com/~william/projects/cqueues.html"
EGIT_COMMIT="8c0142577d3cb1f24917879997678bef0d084815"
SRC_URI="https://github.com/wahern/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="examples"

REQUIRED_USE="${LUA_REQUIRED_USE}"

COMMON_DEPEND="
	${LUA_DEPS}
	dev-libs/openssl:0=
"
DEPEND="
	${COMMON_DEPEND}
	dev-lua/compat53[${LUA_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/cqueues-20200726_p20241204-qa-flags.patch
	"${FILESDIR}"/cqueues-20200726_p20241204-rm-vendor-compat53.patch
)

DOCS=( "doc/." )

lua_src_prepare() {
	pushd "${BUILD_DIR}" || die

	if [[ ${ELUA} != luajit ]]; then
		LUA_VERSION="$(ver_cut 1-2 $(lua_get_version))"
		# these two tests are forced upstream for luajit only
		rm "${BUILD_DIR}"/regress/{44-resolvers-gc,51-join-defunct-thread}.lua || die
	else
		# Thanks to dev-lua/luaossl for this workaround
		# This is a workaround for luajit, as it confirms to lua5.1
		# and the 'GNUmakefile' doesn't understand LuaJITs version.
		LUA_VERSION="5.1"
	fi

	if [[ ${LUA_VERSION} != 5.3 ]]; then
		# this test is forced upstream for lua5-3 only
		rm "${BUILD_DIR}"/regress/152-thread-integer-passing.lua || die
	fi

	# install tests for lua_version only
	sed -e 's:for V in 5.1 5.2 5.3 5.4:for V in '${LUA_VERSION}':' \
		-i "${BUILD_DIR}"/regress/GNUmakefile || die

	popd || die
}

src_prepare() {
	default
	rm -r vendor || die

	# tests deleted :
	# 22, 73, 87 = weak/old ssl
	# 30,62,153 = network required
	rm	regress/22-client-dtls.lua \
		regress/73-starttls-buffering.lua \
		regress/87-alpn-disappears.lua \
		regress/30-starttls-completion.lua \
		regress/62-noname.lua \
		regress/153-dns-resolvers.lua || die

	lua_copy_sources
	lua_foreach_impl lua_src_prepare
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	if [[ ${ELUA} != luajit ]]; then
		LUA_VERSION="$(ver_cut 1-2 $(lua_get_version))"
	else
		LUA_VERSION="5.1"
	fi

	emake CC=$(tc-getCC) \
		all${LUA_VERSION}

	popd || die
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	pushd "${BUILD_DIR}" || die

	emake CC=$(tc-getCC) check

	popd || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	if [[ ${ELUA} != luajit ]]; then
		LUA_VERSION="$(ver_cut 1-2 $(lua_get_version))"
	else
		LUA_VERSION="5.1"
	fi

	emake CC=$(tc-getCC) \
		"DESTDIR=${D}" \
		"lua${LUA_VERSION/./}cpath=$(lua_get_cmod_dir)" \
		"lua${LUA_VERSION/./}path=$(lua_get_lmod_dir)" \
		"prefix=${EPREFIX}/usr" \
		install${LUA_VERSION}

	popd || die
}

src_install() {
	lua_foreach_impl lua_src_install

	use examples && dodoc -r "examples/."
	einstalldocs
}
