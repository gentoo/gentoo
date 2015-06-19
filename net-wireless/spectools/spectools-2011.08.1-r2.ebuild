# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/spectools/spectools-2011.08.1-r2.ebuild,v 1.6 2012/12/11 17:47:41 axs Exp $

EAPI=4
inherit udev toolchain-funcs

MY_PN=${PN}
MY_PV=${PV/\./-}
MY_PV=${MY_PV/./-R}
MY_P="${MY_PN}-${MY_PV}"
S=${WORKDIR}/${MY_P}

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="https://www.kismetwireless.net/code/svn/tools/${PN}"
		inherit subversion
		KEYWORDS=""
else
		SRC_URI="http://www.kismetwireless.net/code/${MY_P}.tar.gz"
		KEYWORDS="amd64 arm ppc x86"
fi

DESCRIPTION="Spectrum Analyzer for Meta-Geek Wi-Spy and GSG Ubertooth hardware"
HOMEPAGE="http://www.kismetwireless.net/spectools/"

LICENSE="GPL-2"
SLOT="0"
IUSE="ncurses gtk"

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

	emake spectool_net spectool_raw

	if use ncurses; then
		emake spectool_curses
	fi

	if use gtk; then
		emake spectool_gtk
	fi

	#if use maemo; then
	#	emake spectool_hildon usbcontrol \
	#		|| die "emake spectool_hildon usbcontrol failed"
	#fi
}

src_install() {
	dobin spectool_net spectool_raw
	use ncurses && dobin spectool_curses
	use gtk && dobin spectool_gtk

	udev_dorules 99-wispy.rules
	dodoc README

	#if use maemo; then
	#	dobin spectool_hildon
	#	dosbin usbcontrol
	#fi
}
