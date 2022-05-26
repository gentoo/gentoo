# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Official authentication app for German ID cards and residence permits"
HOMEPAGE="https://www.ausweisapp.bund.de/"
SRC_URI="https://github.com/Governikus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EUPL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig"

RDEPEND="
	dev-libs/openssl:0=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtsvg:5
	dev-qt/qtwebsockets:5[qml]
	dev-qt/qtwidgets:5
	net-libs/http-parser:0=
	sys-apps/pcsc-lite
	virtual/udev"

DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=( -DBUILD_SHARED_LIBS=OFF )
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
