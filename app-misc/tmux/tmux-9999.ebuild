# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=true

inherit autotools-utils git-r3 bash-completion-r1 flag-o-matic

EGIT_REPO_URI="https://github.com/tmux/tmux.git"

DESCRIPTION="Terminal multiplexer"
HOMEPAGE="http://tmux.github.io/"
SRC_URI=""

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="debug selinux vim-syntax"

COMMON_DEPEND="
	>=dev-libs/libevent-2.0.10
	sys-libs/ncurses"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-screen )
	vim-syntax? ( || (
		app-editors/vim
		app-editors/gvim ) )"

DOCS=( CHANGES FAQ README TODO )

src_prepare() {
	# respect CFLAGS and don't add some includes
	sed \
		-e 's:-I/usr/local/include::' \
		-e 's:-O2::' \
		-i Makefile.am || die

	# bug 438558
	# 1.7 segfaults when entering copy mode if compiled with -Os
	replace-flags -Os -O2

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc
		$(use_enable debug)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	newbashcomp examples/bash_completion_tmux.sh ${PN}

	docinto examples
	dodoc examples/*.conf

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins examples/tmux.vim

		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${FILESDIR}"/tmux.vim
	fi
}
