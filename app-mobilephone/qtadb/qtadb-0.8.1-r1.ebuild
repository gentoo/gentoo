# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=ccbb0c86c9eb
inherit desktop qmake-utils readme.gentoo-r1

DESCRIPTION="Android phone manager via ADB"
HOMEPAGE="https://qtadb.wordpress.com"
SRC_URI="https://bitbucket.org/michalmotyczko/${PN}/get/${COMMIT}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	app-arch/unzip
"

PATCHES=(
	"${FILESDIR}"/${P}-qt5.patch
	"${FILESDIR}"/${P}-qt5-5.11.patch
)

S="${WORKDIR}/michalmotyczko-${PN}-${COMMIT}"

src_configure() {
	eqmake5
}

src_install() {
	newicon images/android.png ${PN}.png
	make_desktop_entry QtADB QtADB ${PN} \
		"Qt;PDA;Utility;" || ewarn "Desktop entry creation failed"
	dobin QtADB

	local DOC_CONTENTS="
You will need a working Android SDK installation (adb and aapt executables)
You can install Android SDK a) through portage (emerge android-sdk-update-manager
and run android to download the actual sdk), b) manually from
http://developer.android.com/sdk/index.html or c) just grab the adb, aapt linux
binaries from http://qtadb.wordpress.com/download/
adb and aapt executables are in the platform-tools subdir of Android SDK.  You
must run QtADB from this directory as a user able to write a log file in this
directory.

Also you will need to have ROOT access to your phone along with busybox
The latter can be found in the Android market

Last, if you want to use the SMS manager of QtADB, you have to install
QtADB.apk to your device, available here: http://qtadb.wordpress.com/download/

If you have trouble getting your phone connected through usb (driver problem),
try adbWireless from Android market to get connected through WiFi
"
	readme.gentoo_create_doc
}
