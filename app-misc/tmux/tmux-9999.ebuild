# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3 flag-o-matic versionator

DESCRIPTION="Terminal multiplexer"
HOMEPAGE="http://tmux.github.io/"
SRC_URI="https://raw.githubusercontent.com/przepompownia/tmux-bash-completion/678a27616b70c649c6701cae9cd8c92b58cc051b/completions/tmux -> tmux-bash-completion-678a27616b70c649c6701cae9cd8c92b58cc051b
vim-syntax? ( https://raw.githubusercontent.com/keith/tmux.vim/95f6126c187667cc7f9c573c45c3b356cf69f4ca/syntax/tmux.vim -> tmux.vim-95f6126c187667cc7f9c573c45c3b356cf69f4ca )"
EGIT_REPO_URI="https://github.com/tmux/tmux.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="debug selinux utempter vim-syntax kernel_FreeBSD kernel_linux"

CDEPEND="
	dev-libs/libevent:0=
	utempter? (
		kernel_linux? ( sys-libs/libutempter )
		kernel_FreeBSD? ( || ( >=sys-freebsd/freebsd-lib-9.0 sys-libs/libutempter ) )
	)
	sys-libs/ncurses:0="
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	dev-libs/libevent:=
	selinux? ( sec-policy/selinux-screen )
	vim-syntax? (
		|| (
			app-editors/vim
			app-editors/gvim
		)
	)"

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

	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc
		$(use_enable debug)
		$(use_enable utempter)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	einstalldocs

	dodoc example_tmux.conf
	docompress -x /usr/share/doc/${PF}/example_tmux.conf

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${FILESDIR}"/tmux.vim
	fi
}

pkg_postinst() {
	if ! version_is_at_least 1.9a ${REPLACING_VERSIONS:-1.9a}; then
		echo
		ewarn "Some configuration options changed in this release."
		ewarn "Please read the CHANGES file in /usr/share/doc/${PF}/"
		ewarn
		ewarn "WARNING: After updating to ${P} you will _not_ be able to connect to any"
		ewarn "older, running tmux server instances. You'll have to use an existing client to"
		ewarn "end your old sessions or kill the old server instances. Otherwise you'll have"
		ewarn "to temporarily downgrade to access them."
		echo
	fi
}
