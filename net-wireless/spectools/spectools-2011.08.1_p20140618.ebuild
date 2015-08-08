# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit udev toolchain-funcs

MY_PN=${PN}
MY_PV=${PV/\./-}
MY_PV=${MY_PV/./-R}
MY_P="${MY_PN}-${MY_PV}"
S=${WORKDIR}/${MY_P}

if [[ ${PV} == "9999" ]] ; then
		EGIT_REPO_URI="https://www.kismetwireless.net/${PN}.git"
		inherit git-r3
		KEYWORDS=""
else
		SRC_URI="https://dev.gentoo.org/~zerochaos/distfiles/${MY_P}.tar.xz"
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
fi

DESCRIPTION="Spectrum Analyzer for Meta-Geek Wi-Spy and GSG Ubertooth hardware"
HOMEPAGE="http://www.kismetwireless.net/spectools/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug +ncurses +gtk"

RDEPEND="virtual/libusb:0
	ncurses? ( sys-libs/ncurses )
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
# Upstream has still not migrated to the libusb-1 line.
# Maemo: Add hildon and bbus

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
