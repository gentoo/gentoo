# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )
inherit autotools lua-single prefix

DESCRIPTION="Environment Module System based on Lua"
HOMEPAGE="https://lmod.readthedocs.io/en/latest https://github.com/TACC/Lmod"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TACC/Lmod"
else
	SRC_URI="https://github.com/TACC/Lmod/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/Lmod-${PV}
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+auto-swap +cache duplicate-paths test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}
	dev-lang/tcl
	dev-lang/tk
	$(lua_gen_cond_dep '
		>=dev-lua/luafilesystem-1.8.0[${LUA_USEDEP}]
		dev-lua/luajson[${LUA_USEDEP}]
		dev-lua/luaposix[${LUA_USEDEP}]
		dev-lua/lua-term[${LUA_USEDEP}]
	')
	virtual/pkgconfig
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}
	test? (
		$(lua_gen_cond_dep '
			dev-util/hermes[${LUA_SINGLE_USEDEP}]
		')
		app-shells/tcsh
	)
"

PATCHES=( "${FILESDIR}"/${PN}-8.4.19-no-libsandbox.patch )

pkg_pretend() {
	elog "You can control the siteName and syshost settings by"
	elog "using the variables LMOD_SITENAME and LMOD_SYSHOST, during"
	elog "build time, which are both set to 'Gentoo' by default."
	elog "There are a lot of options for this package, especially"
	elog "for run time behaviour. Remember to use the EXTRA_ECONF variable."
	elog "To see full list of options visit:"
	elog "\t https://lmod.readthedocs.io/en/latest/090_configuring_lmod.html"
}

src_prepare() {
	default
	rm -r pkgs/{luafilesystem,term} || die
	rm -r rt/{ck_mtree_syntax,colorize,end2end,help,ifur,settarg} || die
	hprefixify -w '/#\!\/bin\/tcsh/' rt/csh_swap/csh_swap.tdesc || die
	eautoreconf
}

src_configure() {
	local LMOD_SITENAME="${LMOD_SITENAME:-Gentoo}"
	local LMOD_SYSHOST="${LMOD_SYSHOST:-Gentoo}"

	local LUAC="${LUA%/*}/luac${LUA#*lua}"

	local myconf=(
		--with-tcl
		--with-fastTCLInterp
		--with-colorize
		--with-supportKsh
		--without-useBuiltinPkgs
		--with-siteControlPrefix
		--with-siteName="${LMOD_SITENAME}"
		--with-syshost="${LMOD_SYSHOST}"
		--with-lua_include="$(lua_get_include_dir)"
		--with-lua="${LUA}"
		--with-luac="${LUAC}"
		--with-module-root-path="${EPREFIX}/etc/modulefiles"
		--with-spiderCacheDir="${EPREFIX}/etc/lmod_cache/spider_cache"
		--with-updateSystemFn="${EPREFIX}/etc/lmod_cache/system.txt"
		--prefix="${EPREFIX}/usr/share/Lmod"
		--with-caseIndependentSorting
		--without-hiddenItalic
		--with-exportedModuleCmd
		--with-useDotFiles
		--without-redirect
		--with-extendedDefault
		$(use_with cache cachedLoads)
		$(use_with duplicate-paths duplicatePaths)
		$(use_with auto-swap autoSwap)
	)
	econf "${myconf[@]}"
}

src_compile() {
	CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
	default
}

src_test() {
	local -x PATH="${EPREFIX}/opt/hermes/bin:${PATH}"
	tm -vvv || die
	testcleanup || die
}

src_install() {
	default
	newman "${FILESDIR}"/module.1-8.4.20 module.1
	# not a real man page
	rm -r "${ED}"/usr/share/Lmod/share/man || die
	doenvd "${FILESDIR}"/99lmod
	keepdir /etc/modulefiles
	keepdir /etc/lmod_cache
}

pkg_postinst() {
	if use cache ; then
		elog "Lmod spider cache has been enabled."
		elog "Remember to update the spider cache with"
		elog "/usr/share/Lmod/libexec/update_lmod_system_cache_files \ "
		elog "\t \$MODULEPATH"
	fi
}
