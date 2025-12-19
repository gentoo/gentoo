# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic systemd

DESCRIPTION="Terminal multiplexer"
HOMEPAGE="https://tmux.github.io/"
if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tmux/tmux.git"
else
	SRC_URI="https://github.com/tmux/tmux/releases/download/${PV}/${P/_/-}.tar.gz"
	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
	fi
	S="${WORKDIR}/${P/_/-}"
fi

LICENSE="ISC"
SLOT="0"
IUSE="debug jemalloc selinux sixel systemd utempter vim-syntax"

DEPEND="
	dev-libs/libevent:=
	sys-libs/ncurses:=
	jemalloc? ( dev-libs/jemalloc:= )
	systemd? ( sys-apps/systemd:= )
	utempter? ( sys-libs/libutempter )
	kernel_Darwin? ( dev-libs/libutf8proc:= )
"

BDEPEND="
	virtual/pkgconfig
	app-alternatives/yacc
"

RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-screen )
	vim-syntax? ( app-vim/vim-tmux )
"

QA_CONFIG_IMPL_DECL_SKIP=(
	# BSD only functions
	strtonum recallocarray
	# missing on musl, tmux has fallback impl which it uses
	b64_ntop
)

DOCS=( CHANGES README )

PATCHES=(
	"${FILESDIR}"/${PN}-2.4-flags.patch
	"${FILESDIR}"/${PN}-3.5-fix-xterm-sym.patch # merged upstream
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug 438558
	# 1.7 segfaults when entering copy mode if compiled with -Os
	replace-flags -Os -O2

	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc
		$(use_enable debug)
		$(use_enable jemalloc)
		$(use_enable sixel)
		$(use_enable systemd)
		$(use_enable utempter)

		# For now, we only expose this for macOS, because
		# upstream strongly encourage it. I'm not sure it's
		# needed on Linux right now.
		$(use_enable kernel_Darwin utf8proc)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	einstalldocs

	dodoc example_tmux.conf
	docompress -x /usr/share/doc/${PF}/example_tmux.conf

	if use systemd; then
		systemd_newuserunit "${FILESDIR}"/tmux.service tmux@.service
		systemd_newuserunit "${FILESDIR}"/tmux.socket tmux@.socket
	fi
}
