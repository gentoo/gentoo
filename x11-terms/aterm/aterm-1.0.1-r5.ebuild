# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="rxvt compatible terminal emulator with transparency support"
HOMEPAGE="http://aterm.sourceforge.net"
SRC_URI="ftp://ftp.afterstep.org/apps/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="background cjk xgetdefault"

RDEPEND="
	virtual/jpeg:0
	media-libs/libpng:0=
	background? ( media-libs/libafterimage )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libICE
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libXt
"

PATCHES=(
	# Security bug #219746
	"${FILESDIR}/${P}-display-security-issue.patch"
	"${FILESDIR}/${P}-deadkeys.patch"
	"${FILESDIR}/${P}-dpy.patch"
	"${FILESDIR}/${P}-remove-streams.patch"
)

src_prepare() {
	# fix pre-stripped files
	sed -i -e "/INSTALL_PROGRAM/ s:-s::" autoconf/Make.common.in || die "sed Makefile failed"

	default
}

src_configure() {
	local myconf

	use cjk && myconf="$myconf
		--enable-kanji
		--enable-thai
		--enable-big5"

	case "${CHOST}" in
		*-darwin*) myconf="${myconf} --enable-wtmp" ;;
		*-interix*) ;;
		*) myconf="${myconf} --enable-utmp --enable-wtmp"
	esac

	econf \
		$(use_enable xgetdefault) \
		$(use_with background afterimage-config "${EPREFIX}"/usr/bin) \
		--with-terminfo="${EPREFIX}"/usr/share/terminfo \
		--enable-transparency \
		--with-x \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	fowners root:utmp /usr/bin/aterm
	fperms g+s /usr/bin/aterm

	doman doc/aterm.1
	dodoc ChangeLog doc/FAQ doc/README.*
	docinto menu
	dodoc doc/menu/*
}

pkg_postinst() {
	echo
	elog "The transparent background will only work if you have the 'real'"
	elog "root wallpaper set. Some tools that might help include:"
	elog "wmsetbg (x11-wm/windowmaker), and/or media-gfx/feh."
	echo
}
