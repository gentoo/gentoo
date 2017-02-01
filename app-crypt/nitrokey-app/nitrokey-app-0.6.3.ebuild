# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils udev

DESCRIPTION="Cross platform personalization tool for the Nitrokey"
HOMEPAGE="https://github.com/Nitrokey/nitrokey-app"
SRC_URI="https://github.com/Nitrokey/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

mycmakeargs=( -DHAVE_LIBAPPINDICATOR=NO )

src_prepare() {
	cmake-utils_src_prepare
	sed -i "s:DESTINATION lib/udev/rules.d:DESTINATION $(get_udevdir)/rules.d:" \
		CMakeLists.txt || die
}

pkg_postinst() {
	udev_reload
}
