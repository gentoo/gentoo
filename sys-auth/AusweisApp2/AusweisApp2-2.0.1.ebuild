# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Official authentication app for German ID cards and residence permits"
HOMEPAGE="https://www.ausweisapp.bund.de/"
SRC_URI="https://github.com/Governikus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EUPL-1.2"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-qt/qtshadertools:6
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig"

RDEPEND="
	dev-libs/openssl:0=
	dev-qt/qtbase:6[concurrent,network,widgets]
	dev-qt/qtdeclarative:6[widgets]
	dev-qt/qtscxml:6[qml]
	dev-qt/qtsvg:6
	dev-qt/qtwebsockets:6[qml]
	net-libs/http-parser:0=
	sys-apps/pcsc-lite
	virtual/udev"

DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
