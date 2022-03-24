# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Terminal multiplexer"
HOMEPAGE="https://tmux.github.io/"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	SRC_URI="https://raw.githubusercontent.com/przepompownia/tmux-bash-completion/678a27616b70c649c6701cae9cd8c92b58cc051b/completions/tmux -> tmux-bash-completion-678a27616b70c649c6701cae9cd8c92b58cc051b"
	EGIT_REPO_URI="https://github.com/tmux/tmux.git"
else
	SRC_URI="https://github.com/tmux/tmux/releases/download/${PV}/${P/_/-}.tar.gz"
	[[ "${PV}" == *_rc* ]] || \
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
	S="${WORKDIR}/${P/_/-}"
fi

LICENSE="ISC"
SLOT="0"
IUSE="debug selinux utempter vim-syntax"

DEPEND="
	dev-libs/libevent:0=
	sys-libs/ncurses:0=
	utempter? ( sys-libs/libutempter )
"

BDEPEND="
	virtual/pkgconfig
	virtual/yacc
"

RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-screen )
	vim-syntax? ( app-vim/vim-tmux )"

DOCS=( CHANGES README )

PATCHES=(
	"${FILESDIR}/${PN}-2.4-flags.patch"

	# upstream fixes (can be removed with next version bump)
	"${FILESDIR}"/${P}-Fix-crosscompiling-Marco-A-L-Barbosa.patch
)

src_prepare() {
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
}
