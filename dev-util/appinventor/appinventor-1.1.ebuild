# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-setup_${PV}"

DESCRIPTION="MIT App Inventor Setup package"
HOMEPAGE="http://www.appinventor.mit.edu/"
SRC_URI="https://dl.google.com/dl/${PN}/installers/linux/${MY_P}.tar.gz"

LICENSE="android"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sys-libs/ncurses-compat:5
	>=virtual/jre-1.6.0"

S="${WORKDIR}/${MY_P}"

QA_PREBUILT="
	/opt/appinventor/commands-for-Appinventor/adb
	/opt/appinventor/commands-for-Appinventor/emulator
	/opt/appinventor/commands-for-Appinventor/mksdcard"

src_install() {
	insinto /opt/${PN}
	doins -r "${PN}"/extras
	doins -r "${PN}"/from-Android-SDK

	exeinto /opt/${PN}/commands-for-Appinventor/
	doexe "${PN}"/commands-for-Appinventor/*
}
