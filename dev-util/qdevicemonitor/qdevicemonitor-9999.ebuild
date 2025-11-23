# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

DESCRIPTION="Crossplatform log viewer for Android, iOS and text files"
HOMEPAGE="https://github.com/alopatindev/qdevicemonitor"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alopatindev/${PN}"
else
	SRC_URI="https://github.com/alopatindev/qdevicemonitor/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	app-pda/usbmuxd
	dev-qt/qtbase:6[gui,widgets]
	dev-util/android-tools"
DEPEND="${RDEPEND}"

src_configure() {
	cd "${PN}" || die
	export VERSION_WITH_BUILD_NUMBER="${PV}"
	eqmake6
}

src_compile() {
	cd "${PN}" || die
	emake
}

src_install() {
	dobin "${PN}/${PN}"
	dodoc README.md
	newicon -s scalable "icons/app_icon.svg" "${PN}.svg"
	domenu "icons/${PN}.desktop"
}
