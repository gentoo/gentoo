# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils flag-o-matic

DESCRIPTION="Vim-fork focused on extensibility and agility."
HOMEPAGE="https://neovim.io"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/neovim/neovim.git"
else
	SRC_URI="https://github.com/neovim/neovim/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0 vim"
SLOT="0"
IUSE="+nvimpager perl python +jemalloc"

CDEPEND="dev-lang/luajit:2
	>=dev-libs/libtermkey-0.17
	>=dev-libs/libuv-1.2.0
	>=dev-libs/msgpack-1.0.0
	>=dev-libs/unibilium-1.1.1
	dev-libs/libvterm
	dev-lua/lpeg[luajit]
	dev-lua/mpack[luajit]
	jemalloc? ( dev-libs/jemalloc )
"
DEPEND="${CDEPEND}
	virtual/libiconv
	virtual/libintl"
RDEPEND="${CDEPEND}
	perl? ( dev-lang/perl )
	python? ( dev-python/neovim-python-client )"

CMAKE_BUILD_TYPE=RelWithDebInfo

src_prepare() {
	# use our system vim dir
	sed -e '/^# define SYS_VIMRC_FILE/s|$VIM|'"${EPREFIX}"'/etc/vim|' \
		-i src/nvim/globals.h || die

	# add eclass to bash filetypes
	sed -e 's|*.ebuild|*.ebuild,*.eclass|' -i runtime/filetype.vim || die

	cmake-utils_src_prepare
}

src_configure() {
	export USE_BUNDLED_DEPS=OFF
	append-cflags "-Wno-error"
	local mycmakeargs=(
		$(cmake-utils_use_enable jemalloc JEMALLOC)
		-DLIBUNIBILIUM_USE_STATIC=OFF
		-DLIBTERMKEY_USE_STATIC=OFF
		-DLIBVTERM_USE_STATIC=OFF
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
		dosym /usr/share/nvim/runtime/macros/less.sh /usr/bin/nvimpager
	fi
}
