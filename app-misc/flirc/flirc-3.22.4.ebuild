# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop udev unpacker

DESCRIPTION="Allows you to pair any remote control with your computer or media center"
HOMEPAGE="https://flirc.tv/"
SRC_URI="
	amd64?	( https://apt.fury.io/flirc/${P}-amd64 -> ${P}_amd64.deb )
	arm?	( https://apt.fury.io/flirc/${P}-armhf -> ${P}_arm.deb   )
	x86?	( https://apt.fury.io/flirc/${P}-i386  -> ${P}_x86.deb   )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~x86"
IUSE="+qt5"

RESTRICT="bindist mirror strip"

S="${WORKDIR}"

DEPEND=""
RDEPEND="virtual/libusb:1
	dev-libs/hidapi
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		dev-qt/qtxmlpatterns:5 )"

QA_PREBUILT="/usr/bin/*"

src_install () {
	udev_newrules etc/udev/rules.d/99-flirc.rules 51-flirc.rules
	dobin usr/bin/flirc_util
	doman usr/share/doc/flirc/flirc_util.1
	if use qt5 ; then
		dobin usr/bin/Flirc
		doman usr/share/doc/flirc/Flirc.1
		doicon usr/share/pixmaps/Flirc.png
		domenu usr/share/applications/Flirc.desktop
	fi
}
