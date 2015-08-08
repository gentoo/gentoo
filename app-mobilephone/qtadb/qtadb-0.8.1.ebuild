# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils readme.gentoo qt4-r2

MY_PN="QtADB"
MY_P="${MY_PN}_${PV}_src"

DESCRIPTION="Android phone manager via ADB"
HOMEPAGE="http://qtadb.wordpress.com"
SRC_URI="http://${PN}.com/${PN}/${MY_P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtgui:4
	dev-qt/qtdeclarative:4"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/trunk"

pkg_setup() {
	DISABLE_AUTOFORMATTING="yes"
	DOC_CONTENTS="
You will need a working Android SDK installation (adb and aapt executables)
You can install Android SDK a) through portage (emerge android-sdk-update-manager
and run android to download the actual sdk), b) manually from
http://developer.android.com/sdk/index.html or c) just grab the adb, aapt linux
binaries from http://qtadb.wordpress.com/download/
adb and aapt executables are in the platform-tools subdir of Android SDK

Also you will need to have ROOT access to your phone along with busybox
The latter can be found in the Android market

Last, if you want to use the SMS manager of QtADB, you have to install
QtADB.apk to your device, available here: http://qtadb.wordpress.com/download/

If you have trouble getting your phone connected through usb (driver problem),
try adbWireless from Android market to get connected through WiFi
"
}

src_install() {
	newicon images/android.png ${PN}.png
	make_desktop_entry ${MY_PN} "${MY_PN}" ${PN} \
		"Qt;PDA;Utility;" || die "Desktop entry creation failed"
	dobin ${MY_PN}
	readme.gentoo_create_doc
}
