# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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

if [[ ${PV} == 2.1.9999999999 ]]; then
	# This is the 2.1 rolling release live build. When a 2.2 or 3.x branch comes
	# out, create a new ebuild for it.
	#
	# Upstream recommends pulling rolling releases from the v2.1 branch.
	# > The old git master branch is phased out and stays pinned to the v2.0
	# > branch. Please follow the versioned branches instead.
	#
	# See http://luajit.org/status.html for additional information.
	EGIT_BRANCH="v2.1"
	EGIT_REPO_URI="https://luajit.org/git/luajit.git"
	inherit git-r3
else
	# Update this commit hash to bump a pinned-commit ebuild.
	GIT_COMMIT=""
	SRC_URI="https://github.com/LuaJIT/LuaJIT/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/LuaJIT-${GIT_COMMIT}"

	KEYWORDS="~amd64 ~arm ~arm64 -hppa ~mips ~ppc -riscv -sparc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"
# this should probably be pkgmoved to 2.1 for sake of consistency.
SLOT="2/${PV}"
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
