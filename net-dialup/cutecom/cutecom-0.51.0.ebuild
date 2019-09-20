# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils

DESCRIPTION="CuteCom is a serial terminal, like minicom, written in qt"
HOMEPAGE="https://gitlab.com/cutecom/cutecom"
SRC_URI="https://gitlab.com/cutecom/cutecom/-/archive/v${PV}/cutecom-v${PV}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtserialport:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}
	net-dialup/lrzsz"

S="${WORKDIR}/cutecom-v${PV}"

src_prepare() {
	sed -i \
		-e '/Path/d' \
		-e '/Terminal/s/0/false/' \
		"${PN}.desktop" || die 'sed on desktop file failed'

	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install
	domenu "${PN}.desktop"
	doicon "distribution/${PN}.png"
}
