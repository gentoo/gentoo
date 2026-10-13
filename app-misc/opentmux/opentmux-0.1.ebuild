# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools eapi9-ver systemd

DESCRIPTION="Terminal multiplexer, slop-free fork of app-misc/tmux"
HOMEPAGE="https://codeberg.org/opentmux/opentmux"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://codeberg.org/opentmux/opentmux.git"
else
	SRC_URI="https://codeberg.org/opentmux/opentmux/releases/download/v${PV}/${P}.tar.gz"
	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
	fi
fi

LICENSE="ISC"
SLOT="0"
IUSE="debug jemalloc selinux sixel systemd utempter vim-syntax"
# Tests fail but not yet clear why. They weren't ever wired up for
# tmux so not too worried about it.
RESTRICT="test"

DEPEND="
	dev-libs/libevent:=
	sys-libs/ncurses:=
	jemalloc? ( dev-libs/jemalloc:= )
	systemd? ( sys-apps/systemd:= )
	utempter? ( sys-libs/libutempter )
	kernel_Darwin? ( dev-libs/libutf8proc:= )
"
RDEPEND="
	${DEPEND}
	!app-misc/tmux
	selinux? ( sec-policy/selinux-screen )
	vim-syntax? ( app-vim/vim-tmux )
"
BDEPEND="
	app-alternatives/yacc
	virtual/pkgconfig
"

QA_CONFIG_IMPL_DECL_SKIP=(
	# BSD only functions
	strtonum recallocarray
	# missing on musl, tmux has fallback impl which it uses
	b64_ntop
)

DOCS=( CHANGES README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-2.4-flags.patch
	"${FILESDIR}"/${PN}-3.6a-race-fork.patch
	"${FILESDIR}"/${PN}-3.6a-pane-color.patch
	"${FILESDIR}"/${PN}-3.6a-sixel.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
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

src_test() {
	emake -C regress -Onone
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

pkg_postinst() {
	# https://github.com/tmux/tmux/issues/4711
	# TODO: Does opentmux provide different guarantees to tmux here?
	if ver_replacing -lt 3.6a ; then
		ewarn "Please restart all running opentmux sessions (client+server)."
		ewarn "3.6a has an incompatible protocol change, so it is especially important:"
		ewarn " https://github.com/tmux/tmux/issues/4699#issue-3666479306"
	elif ver_replacing -lt ${PV} ; then
		# https://github.com/tmux/tmux/issues/4699#issue-3666479306
		# > Note that it is very important to restart tmux entirely after upgrading.
		# > This is particularly important with this release because one of the libraries
		# > that tmux uses changed its protocol.
		ewarn "Please restart all running opentmux clients+servers after upgrading opentmux."
	fi
}
