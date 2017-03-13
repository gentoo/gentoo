# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils flag-o-matic toolchain-funcs udev

MY_PN=${PN}
MY_PV=${PV/\./-}
MY_PV=${MY_PV/./-R}
MY_P="${MY_PN}-${MY_PV}"
S=${WORKDIR}/${MY_P}

if [[ ${PV} == "9999" ]] ; then
		EGIT_REPO_URI="https://www.kismetwireless.net/${PN}.git"
		inherit git-r3
		KEYWORDS="amd64"
else
		SRC_URI="http://www.kismetwireless.net/code/${MY_P}.tar.xz"
		KEYWORDS="amd64 ~arm ~arm64 ~ppc ~x86"
fi

DESCRIPTION="Spectrum Analyzer for Meta-Geek Wi-Spy and GSG Ubertooth hardware"
HOMEPAGE="http://www.kismetwireless.net/spectools/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug +ncurses +gtk"

RDEPEND="
	virtual/libusb:0
	ncurses? ( sys-libs/ncurses:0= )
	gtk? ( x11-libs/gtk+:2
		x11-libs/cairo
		x11-libs/gdk-pixbuf
		x11-libs/pango
		dev-libs/glib:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
# Upstream has still not migrated to the libusb-1 line.

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2011.08.1_p20140618-tinfo.patch
	mv configure.{in,ac} || die
	eautoreconf

	# fix bug 577466 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89
}

# Please note that upstream removed the --with-gtk-version option
# and GTK is now automagical. GTK1 support was also removed.
src_compile() {
	emake depend

	emake spectool_net

	use debug && emake spectool_raw

	use ncurses && emake spectool_curses

	use gtk && emake spectool_gtk

	#if use maemo; then
	#	emake spectool_hildon usbcontrol \
	#		|| die "emake spectool_hildon usbcontrol failed"
	#fi
}

src_install() {
	dobin spectool_net
	use debug && dobin spectool_raw
	use ncurses && dobin spectool_curses
	use gtk && dobin spectool_gtk

	udev_dorules 99-wispy.rules
	dodoc README

	#if use maemo; then
	#	dobin spectool_hildon
	#	dosbin usbcontrol
	#fi
}
