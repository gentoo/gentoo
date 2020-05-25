# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Official authentication app for German ID cards and residence permits"
HOMEPAGE="https://www.ausweisapp.bund.de/"
SRC_URI="https://github.com/Governikus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EUPL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwebsockets:5[qml]
	dev-qt/qtwidgets:5
	dev-qt/qtdeclarative
	dev-libs/openssl:0=
	sys-apps/pcsc-lite
	net-libs/http-parser:0=
	virtual/udev"

DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
	dev-qt/qtquickcontrols2:5
	dev-qt/linguist-tools:5"

src_configure() {
	local mycmakeargs=( -DBUILD_SHARED_LIBS=OFF )
	cmake_src_configure
}
