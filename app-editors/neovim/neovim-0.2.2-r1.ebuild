# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="Vim-fork focused on extensibility and agility."
HOMEPAGE="https://neovim.io"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/neovim/neovim.git"
else
	SRC_URI="https://github.com/neovim/neovim/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0 vim"
SLOT="0"
IUSE="+clipboard +luajit +nvimpager python remote ruby +tui +jemalloc"

CDEPEND=">=dev-libs/libuv-1.2.0
	>=dev-libs/msgpack-1.0.0
	luajit? ( dev-lang/luajit:2 )
	!luajit? (
		dev-lang/lua:=
		dev-lua/LuaBitOp
	)
	tui? (
		>=dev-libs/libtermkey-0.19
		>=dev-libs/unibilium-1.1.1:=
	)
	dev-libs/libvterm
	dev-lua/lpeg[luajit=]
	dev-lua/mpack[luajit=]
	jemalloc? ( dev-libs/jemalloc )"

DEPEND="
	${CDEPEND}
	dev-util/gperf
	virtual/libiconv
	virtual/libintl"

RDEPEND="
	${CDEPEND}
	python? ( dev-python/neovim-python-client )
	ruby? ( dev-ruby/neovim-ruby-client )
	remote? ( dev-python/neovim-remote )
	clipboard? ( || ( x11-misc/xsel x11-misc/xclip ) )"

CMAKE_BUILD_TYPE=Release

src_prepare() {
	# use our system vim dir
	sed -e '/^# define SYS_VIMRC_FILE/s|$VIM|'"${EPREFIX}"'/etc/vim|' \
		-i src/nvim/globals.h || die

	# add eclass to bash filetypes
	sed -e 's|*.ebuild|*.ebuild,*.eclass|' -i runtime/filetype.vim || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DFEAT_TUI=$(usex tui)
		-DENABLE_JEMALLOC=$(usex jemalloc)
		-DPREFER_LUA=$(usex luajit no yes)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# install a default configuration file
	insinto /etc/vim
	doins "${FILESDIR}"/sysinit.vim

	# conditionally install a symlink for nvimpager
	if use nvimpager; then
		dosym ../share/nvim/runtime/macros/less.sh /usr/bin/nvimpager
	fi
}
