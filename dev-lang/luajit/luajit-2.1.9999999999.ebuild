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

# Split release channel (such as "2.1") from relver (such as "1727870382")
VER_CHANNEL=${PV%.*}
VER_RELVER=${PV##*.}

DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="https://luajit.org/"

if [[ ${VER_RELVER} == 9999999999 ]]; then
	# Upstream recommends pulling rolling releases from versioned branches.
	# > The old git master branch is phased out and stays pinned to the v2.0
	# > branch. Please follow the versioned branches instead.
	#
	# See http://luajit.org/status.html for additional information.
	EGIT_BRANCH="v${VER_CHANNEL}"
	EGIT_REPO_URI="https://luajit.org/git/luajit.git"
	inherit git-r3
else
	# Update this commit hash to bump a pinned-commit ebuild.
	GIT_COMMIT=""
	SRC_URI="https://github.com/LuaJIT/LuaJIT/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/LuaJIT-${GIT_COMMIT}"

	KEYWORDS="~amd64 ~arm ~arm64 -hppa ~mips ~ppc -riscv -sparc ~x86"
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
		TARGET_SHLDFLAGS="${LDFLAGS}" \
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

	# For tarballs downloaded from github, the relver is provided in
	# ${S}/.relver, a file populated when generating the tarball as directed by
	# .gitattributes. That file will contain the same relver as the relver
	# in our version number.
	#
	# For the live build, this is not populated, but luajit's build process
	# inspects the git repository directly with this command:
	#
	#     git show -s --format=%ct
	#
	# In both cases, luajit puts the relver in src/luajit_relver.txt during
	# the build. We read this file to ensure we're using the same source of
	# truth as luajit's own build does when generating the binary's filename.
	local relver="$(cat "${S}/src/luajit_relver.txt" || die 'error retrieving relver')"
	dosym luajit-"${VER_CHANNEL}.${relver}" /usr/bin/luajit

	HTML_DOCS="doc/." einstalldocs
}
