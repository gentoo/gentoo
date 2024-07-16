# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GIT_COMMIT=93e87998b24021b94de8d1c8db244444c46fb6e9

# Upstream doesn't make releases anymore and instead have a (broken) "rolling
# git tag" model.
#
# https://github.com/LuaJIT/LuaJIT/issues/665#issuecomment-784452583
# https://www.freelists.org/post/luajit/LuaJIT-uses-rolling-releases
#
# Regular snapshots should be made from the v2.1 branch. Get the version with
# `git show -s --format=%ct`

inherit toolchain-funcs

DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="https://luajit.org/"
SRC_URI="https://github.com/LuaJIT/LuaJIT/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/LuaJIT-${GIT_COMMIT}"

LICENSE="MIT"
# this should probably be pkgmoved to 2.0 for sake of consistency.
SLOT="2/${PV}"
KEYWORDS="amd64 ~arm ~arm64 -hppa ~mips ~ppc -riscv -sparc x86 ~amd64-linux ~x86-linux"
IUSE="lua52compat static-libs"

_emake() {
	emake \
		Q= \
		PREFIX="${EPREFIX}/usr" \
		MULTILIB="$(get_libdir)" \
		DESTDIR="${D}" \
		CFLAGS="" \
		LDFLAGS="" \
		HOST_CC="$(tc-getBUILD_CC)" \
		HOST_CFLAGS="${BUILD_CPPFLAGS} ${BUILD_CFLAGS}" \
		HOST_LDFLAGS="${BUILD_LDFLAGS}" \
		STATIC_CC="$(tc-getCC)" \
		DYNAMIC_CC="$(tc-getCC) -fPIC" \
		TARGET_LD="$(tc-getCC)" \
		TARGET_CFLAGS="${CPPFLAGS} ${CFLAGS}" \
		TARGET_LDFLAGS="${LDFLAGS}" \
		TARGET_AR="$(tc-getAR) rcus" \
		BUILDMODE="$(usex static-libs mixed dynamic)" \
		TARGET_STRIP="true" \
		INSTALL_LIB="${ED}/usr/$(get_libdir)" \
		"$@"
}

src_compile() {
	tc-export_build_env
	_emake XCFLAGS="$(usex lua52compat "-DLUAJIT_ENABLE_LUA52COMPAT" "")"
}

src_install() {
	_emake install
	dosym luajit-"${PV}" /usr/bin/luajit

	HTML_DOCS="doc/." einstalldocs
}
