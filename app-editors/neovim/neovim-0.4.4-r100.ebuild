# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..2} luajit )

inherit cmake lua-single optfeature xdg

DESCRIPTION="Vim-fork focused on extensibility and agility."
HOMEPAGE="https://neovim.io"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/neovim/neovim.git"
else
	SRC_URI="https://github.com/neovim/neovim/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

LICENSE="Apache-2.0 vim"
SLOT="0"
IUSE="+lto +nvimpager +tui"

REQUIRED_USE="${LUA_REQUIRED_USE}"
# Upstream say the test library needs LuaJIT
# https://github.com/neovim/neovim/blob/91109ffda23d0ce61cec245b1f4ffb99e7591b62/CMakeLists.txt#L377
#REQUIRED_USE="test? ( lua_single_target_luajit )"
#RESTRICT="!test? ( test )"

# Upstream build scripts invoke the Lua interpreter
BDEPEND="${LUA_DEPS}
	dev-util/gperf
	virtual/libiconv
	virtual/libintl
	virtual/pkgconfig
"
# TODO: add tests, dev-lua/busted has now got luajit support.
# bug #584694
DEPEND="${LUA_DEPS}
	dev-lua/luv[${LUA_SINGLE_USEDEP}]
	$(lua_gen_cond_dep '
		dev-lua/lpeg[${LUA_USEDEP}]
		dev-lua/mpack[${LUA_USEDEP}]
	')
	$(lua_gen_cond_dep '
		dev-lua/LuaBitOp[${LUA_USEDEP}]
	' lua5-{1,2})
	dev-libs/libuv:0=
	>=dev-libs/libvterm-0.1.2
	dev-libs/msgpack:0=
	net-libs/libnsl
	tui? (
		dev-libs/libtermkey
		>=dev-libs/unibilium-2.0.0:0=
	)
"
RDEPEND="
	${DEPEND}
	app-eselect/eselect-vi
"

PATCHES=(
	"${FILESDIR}/${PN}-0.4.4-cmake_lua_version.patch"
	"${FILESDIR}/${PN}-0.4.4-cmake-release-type.patch"
)

src_prepare() {
	# use our system vim dir
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
	local mycmakeargs=(
		-DENABLE_LTO=$(usex lto)
		-DFEAT_TUI=$(usex tui)
		-DPREFER_LUA=$(usex lua_single_target_luajit no "$(lua_get_version)")
		-DLUA_PRG="${ELUA}"
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
