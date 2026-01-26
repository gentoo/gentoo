# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="4d90f45d6c204ad87b2198791fe522be092bed98"
inherit desktop qmake-utils xdg

DESCRIPTION="Crossplatform log viewer for Android, iOS and text files"
HOMEPAGE="https://github.com/alopatindev/qdevicemonitor"
SRC_URI="https://github.com/alopatindev/qdevicemonitor/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	virtual/libudev:="
RDEPEND="${DEPEND}
	app-pda/usbmuxd
	dev-util/android-tools"

DOCS=( ../README.md )

src_configure() {
	export VERSION_WITH_BUILD_NUMBER="${PV}-${COMMIT:0:8}"
	eqmake6
}

src_install() {
	dobin "${PN}"
	einstalldocs
	newicon -s scalable "../icons/app_icon.svg" "${PN}.svg"
	domenu "../icons/${PN}.desktop"
}
