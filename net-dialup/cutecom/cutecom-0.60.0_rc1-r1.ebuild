# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

MY_PV=${PV/_rc/-RC}

DESCRIPTION="Serial terminal, like minicom, written in Qt"
HOMEPAGE="https://gitlab.com/cutecom/cutecom"
SRC_URI="https://gitlab.com/cutecom/cutecom/-/archive/v${MY_PV}/cutecom-v${MY_PV}.tar.bz2"
S="${WORKDIR}/cutecom-v${MY_PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

DEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qtserialport:6"
RDEPEND="${DEPEND}
	net-dialup/lrzsz"

src_install() {
	cmake_src_install
	doicon "distribution/${PN}.png"
}
