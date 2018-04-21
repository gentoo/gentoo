# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop udev unpacker

DESCRIPTION="Allows you to pair any remote control with your computer or media center"
HOMEPAGE="https://flirc.tv/"
SRC_URI="
	amd64?	( https://packagecloud.io/Flirc/repo/packages/ubuntu/artful/flirc_${PV}_amd64.deb/download.deb  -> ${P}_amd64.deb )
	arm?	( https://packagecloud.io/Flirc/repo/packages/debian/stretch/flirc_${PV}_armhf.deb/download.deb -> ${P}_armhf.deb )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm"
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
	doman usr/share/doc/flirc/flirc_util.1
	dobin usr/bin/flirc_util
	if use qt5 ; then
		doman usr/share/doc/flirc/Flirc.1
		dobin usr/bin/Flirc
		doicon usr/share/pixmaps/Flirc.png
		domenu usr/share/applications/Flirc.desktop
	fi
}
