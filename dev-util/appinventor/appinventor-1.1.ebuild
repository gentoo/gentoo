# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

MY_P="${PN}-setup_${PV}"
DESCRIPTION="MIT App Inventor Setup package"
HOMEPAGE="http://www.appinventor.mit.edu/"
SRC_URI="https://dl.google.com/dl/${PN}/installers/linux/${MY_P}.tar.gz"

LICENSE="android"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.6.0"

APP_INSTALL_DIR="/opt/${PN}"
S="${WORKDIR}/${MY_P}"
QA_PREBUILT="/opt/appinventor/commands-for-Appinventor/adb
	/opt/appinventor/commands-for-Appinventor/emulator
	/opt/appinventor/commands-for-Appinventor/mksdcard"

src_install() {
	insinto ${APP_INSTALL_DIR}
	dodir ${APP_INSTALL_DIR}
	doins -r "${PN}"/extras
	doins -r "${PN}"/from-Android-SDK
	exeinto "${APP_INSTALL_DIR}"/commands-for-Appinventor/
	doexe "${PN}"/commands-for-Appinventor/*
}
