# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Powerful yet simple to use screenshot software"
HOMEPAGE="https://flameshot.org https://github.com/flameshot-org/flameshot"
SRC_URI="https://github.com/flameshot-org/flameshot/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 Free-Art-1.3 GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	=dev-qt/qtsingleapplication-2.6*[qt5(+),X]
	dev-qt/qtwidgets:5
	dev-qt/qtsvg:5
	dev-qt/qtnetwork:5
	dev-qt/qtdbus:5
	sys-apps/dbus
"
BDEPEND="
	dev-qt/linguist-tools:5
"
RDEPEND="${DEPEND}"

src_prepare() {
	rm -r external/singleapplication || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_EXTERNAL_SINGLEAPPLICATION=1
		-DENABLE_CACHE=0
	)

	cmake_src_configure
}
