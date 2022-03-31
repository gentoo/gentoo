# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..2} luajit )

inherit cmake lua-single optfeature xdg

DESCRIPTION="Vim-fork focused on extensibility and agility"
HOMEPAGE="https://neovim.io"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/neovim/neovim.git"
else
	SRC_URI="https://github.com/neovim/neovim/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~riscv x86 ~x64-macos"
fi

LICENSE="Apache-2.0 vim"
SLOT="0"
IUSE="+lto +nvimpager test +tui"

REQUIRED_USE="${LUA_REQUIRED_USE}"
# Upstream say the test library needs LuaJIT
# https://github.com/neovim/neovim/blob/91109ffda23d0ce61cec245b1f4ffb99e7591b62/CMakeLists.txt#L377
REQUIRED_USE="test? ( lua_single_target_luajit )"
# TODO: Get tests running
RESTRICT="!test? ( test ) test"

# Upstream build scripts invoke the Lua interpreter
BDEPEND="${LUA_DEPS}
	>=dev-util/gperf-3.1
	virtual/libiconv
	virtual/libintl
	virtual/pkgconfig
"
# Check https://github.com/neovim/neovim/blob/master/third-party/CMakeLists.txt for
# new dependency bounds and so on on bumps (obviously adjust for right branch/tag).
DEPEND="${LUA_DEPS}
	>=dev-lua/luv-1.42.0[${LUA_SINGLE_USEDEP}]
	$(lua_gen_cond_dep '
		dev-lua/lpeg[${LUA_USEDEP}]
		dev-lua/mpack[${LUA_USEDEP}]
	')
	$(lua_gen_cond_dep '
		dev-lua/LuaBitOp[${LUA_USEDEP}]
	' lua5-{1,2})
	>=dev-libs/libuv-1.42.0:=
	>=dev-libs/libvterm-0.1.4
	>=dev-libs/msgpack-3.0.0:=
	>=dev-libs/tree-sitter-0.20.1:=
	tui? (
		>=dev-libs/libtermkey-0.22
		>=dev-libs/unibilium-2.0.0:0=
	)
"
RDEPEND="
	${DEPEND}
	app-eselect/eselect-vi
"
BDEPEND="
	test? (
		$(lua_gen_cond_dep 'dev-lua/busted[${LUA_USEDEP}]')
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.4.4-cmake_lua_version.patch"
	"${FILESDIR}/${PN}-0.4.4-cmake-release-type.patch"
	"${FILESDIR}/${PN}-0.4.4-cmake-darwin.patch"
)

src_prepare() {
	# Use our system vim dir
	sed -e "/^# define SYS_VIMRC_FILE/s|\$VIM|${EPREFIX}/etc/vim|" \
		-i src/nvim/globals.h || die

	cmake_src_prepare
}

src_configure() {
	# Upstream default to LTO on non-debug builds
	# Let's expose it as a USE flag because upstream
	# have preferences for how we should use LTO
	# if we want it on (not just -flto)
	# ... but allow turning it off.
	# TODO: Investigate USE_BUNDLED, doesn't seem to be needed right now
	local mycmakeargs=(
		-DENABLE_LTO=$(usex lto)
		-DFEAT_TUI=$(usex tui)
		-DPREFER_LUA=$(usex lua_single_target_luajit no "$(lua_get_version)")
		-DLUA_PRG="${ELUA}"
		-DMIN_LOG_LEVEL=3
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# install a default configuration file
	insinto /etc/vim
	doins "${FILESDIR}"/sysinit.vim

	# conditionally install a symlink for nvimpager
	if use nvimpager; then
		dosym ../share/nvim/runtime/macros/less.sh /usr/bin/nvimpager
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "clipboard support" x11-misc/xsel x11-misc/xclip gui-apps/wl-clipboard
	optfeature "Python plugin support" dev-python/pynvim
	optfeature "Ruby plugin support" dev-ruby/neovim-ruby-client
	optfeature "remote/nvr support" dev-python/neovim-remote
}
