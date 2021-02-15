# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg cmake

DESCRIPTION="Corsair K65/K70/K95 Driver"
HOMEPAGE="https://github.com/ckb-next/ckb-next"
SRC_URI="https://github.com/ckb-next/ckb-next/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/quazip-0.7.2:0[qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	virtual/libudev:=
	x11-libs/libX11"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-next-${PV}"

PATCHES=( "${FILESDIR}"/${P}-gcc10.patch )

src_configure() {
	local mycmakeargs=(
		-DDISABLE_UPDATER=yes
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc CHANGELOG.md

	newinitd "${FILESDIR}"/ckb.initd ckb-daemon
}
