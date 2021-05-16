# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

DESCRIPTION="A serial terminal, like minicom, written in Qt"
HOMEPAGE="https://gitlab.com/cutecom/cutecom"
SRC_URI="https://gitlab.com/cutecom/cutecom/-/archive/v${PV}/cutecom-v${PV}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtserialport:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}
	net-dialup/lrzsz"

S="${WORKDIR}/cutecom-v${PV}"

PATCHES=( "${FILESDIR}"/${P}-fix-for-qt-5.15.0.patch )

src_prepare() {
	cmake_src_prepare

	sed -i \
		-e '/Path/d' \
		-e '/Terminal/s/0/false/' \
		"${PN}.desktop" || die 'sed on desktop file failed'
}

src_install() {
	cmake_src_install
	domenu "${PN}.desktop"
	doicon "distribution/${PN}.png"
}
