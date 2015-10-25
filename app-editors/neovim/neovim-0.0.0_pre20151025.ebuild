# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils eutils flag-o-matic

DESCRIPTION="Vim-fork focused on extensibility and agility."
HOMEPAGE="https://github.com/neovim/neovim"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/neovim/neovim.git"
else
	SRC_URI="https://dev.gentoo.org/~tranquility/distfiles/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0 vim"
SLOT="0"
IUSE="+nvimpager perl python jemalloc"

CDEPEND="dev-lang/luajit:2
	>=dev-libs/libtermkey-0.17
	>=dev-libs/libuv-1.2.0
	>=dev-libs/msgpack-0.6.0_pre20150220
	>=dev-libs/unibilium-1.1.1
	dev-libs/libvterm
	dev-lua/lpeg
	dev-lua/messagepack
	jemalloc? ( dev-libs/jemalloc )
"
DEPEND="${CDEPEND}
	virtual/libiconv
	virtual/libintl"
RDEPEND="${CDEPEND}
	perl? ( dev-lang/perl )
	python? ( dev-python/neovim-python-client )"

src_prepare() {
	# use our system vim dir
	sed -e '/^# define SYS_VIMRC_FILE/s|$VIM|'"${EPREFIX}"'/etc/vim|' \
		-i src/nvim/os/unix_defs.h || die

	# add eclass to bash filetypes
	sed -e 's|*.ebuild|*.ebuild,*.eclass|' -i runtime/filetype.vim || die

	# make less.sh macro actually work with neovim
	sed -e 's|vim |nvim |g' -i runtime/macros/less.sh || die

	# make sure the jemalloc dependency is not automagic
	epatch "${FILESDIR}"/automagic-jemalloc.patch

	cmake-utils_src_prepare
}

src_configure() {
	export USE_BUNDLED_DEPS=OFF
	append-cflags "-Wno-error"
	local mycmakeargs=(
		$(cmake-utils_use_enable jemalloc JEMALLOC)
		-DCMAKE_BUILD_TYPE=RelWithDebInfo
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
	doins "${FILESDIR}"/nvimrc

	# conditionally install a symlink for nvimpager
	if use nvimpager; then
		dosym /usr/share/nvim/runtime/macros/less.sh /usr/bin/nvimpager
	fi
}
