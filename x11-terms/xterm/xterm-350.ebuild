# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic multilib

DESCRIPTION="Terminal Emulator for X Windows"
HOMEPAGE="https://invisible-island.net/xterm/"
SRC_URI="ftp://ftp.invisible-island.net/${PN}/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+openpty sixel toolbar truetype unicode Xaw3d xinerama"

BDEPEND="virtual/pkgconfig
	x11-base/xorg-proto"
DEPEND="kernel_linux? ( sys-libs/libutempter )
	kernel_FreeBSD? ( || ( >=sys-freebsd/freebsd-lib-9.0 sys-libs/libutempter ) )
	media-libs/fontconfig:1.0
	>=sys-libs/ncurses-5.7-r7:0=
	x11-apps/xmessage
	x11-libs/libICE
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXft
	x11-libs/libxkbfile
	x11-libs/libXmu
	x11-libs/libXrender
	x11-libs/libXt
	unicode? ( x11-apps/luit )
	Xaw3d? ( x11-libs/libXaw3d )
	xinerama? ( x11-libs/libXinerama )"
RDEPEND="${DEPEND}
	media-fonts/font-misc-misc
	x11-apps/rgb"

DOCS=( README{,.i18n} ctlseqs.txt )

pkg_setup() {
	DEFAULTS_DIR="${EPREFIX}"/usr/share/X11/app-defaults
}

src_configure() {
	# 454736
	# Workaround for ncurses[tinfo] until upstream fixes their buildsystem using
	# something sane like pkg-config or ncurses5-config and stops guessing libs
	# Everything gets linked against ncurses anyways, so don't shout
	append-libs $(pkg-config --libs ncurses)

	local myeconfargs=(
		--disable-full-tgetent
		--disable-imake
		--disable-setgid
		--disable-setuid
		--enable-256-color
		--enable-broken-osc
		--enable-broken-st
		--enable-dabbrev
		--enable-exec-xterm
		--enable-i18n
		--enable-load-vt-fonts
		--enable-logging
		--enable-screen-dumps
		--enable-warnings
		--enable-wide-chars
		--libdir="${EPREFIX}"/etc
		--with-app-defaults="${DEFAULTS_DIR}"
		--with-utempter
		--with-x
		$(use_enable openpty)
		$(use_enable sixel sixel-graphics)
		$(use_enable toolbar)
		$(use_enable truetype freetype)
		$(use_enable unicode luit)
		$(use_enable unicode mini-luit)
		$(use_with Xaw3d)
		$(use_with xinerama)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	docinto html
	dodoc xterm.log.html
	domenu *.desktop

	# Fix permissions -- it grabs them from live system, and they can
	# be suid or sgid like they were in pre-unix98 pty or pre-utempter days,
	# respectively (#69510).
	# (info from Thomas Dickey) - Donnie Berkholz <spyderous@gentoo.org>
	fperms 0755 /usr/bin/xterm

	# restore the navy blue
	sed -i -e 's:blue2$:blue:' "${ED}${DEFAULTS_DIR}"/XTerm-color || die
}
