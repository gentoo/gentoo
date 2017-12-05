# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic versionator

DESCRIPTION="Terminal multiplexer"
HOMEPAGE="http://tmux.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV/_*}/${P/_/-}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug selinux utempter vim-syntax kernel_FreeBSD kernel_linux"

CDEPEND="
	dev-libs/libevent:0=
	sys-libs/ncurses:0=
	utempter? (
		kernel_linux? ( sys-libs/libutempter )
		kernel_FreeBSD? ( || ( >=sys-freebsd/freebsd-lib-9.0 sys-libs/libutempter ) )
	)
"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-screen )
	vim-syntax? (
		|| (
			app-editors/vim
			app-editors/gvim
		)
	)"

DOCS=( CHANGES README TODO )

S="${WORKDIR}/${P/_/-}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4-flags.patch

	# usptream fixes (can be removed with next version bump)
)

src_prepare() {
	# bug 438558
	# 1.7 segfaults when entering copy mode if compiled with -Os
	replace-flags -Os -O2

	# regenerate aclocal.m4 to support earlier automake versions
	rm aclocal.m4 || die

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
