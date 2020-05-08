# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Upstream names the package PV-rX. We change that to
# PV_pX so we can use portage revisions.
MY_P=${PN}-${PV/_p/-r}
inherit xdg cmake

DESCRIPTION="Qt GUI configuration tool for Wine"
HOMEPAGE="https://q4wine.brezblock.org.ua/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+dbus debug +ico +iso +wineappdb"

BDEPEND="
	dev-qt/linguist-tools:5
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dbus? ( dev-qt/qtdbus:5 )
	ico? ( >=media-gfx/icoutils-0.26.0 )
"
RDEPEND="${DEPEND}
	app-admin/sudo
	>=sys-apps/which-2.19
	iso? ( sys-fs/fuseiso )
"

S="${WORKDIR}"/${MY_P}

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	local mycmakeargs=(
		-DDEBUG=$(usex debug ON OFF)
		-DWITH_ICOUTILS=$(usex ico ON OFF)
		-DWITH_SYSTEM_SINGLEAPP=ON
		-DWITH_WINEAPPDB=$(usex wineappdb ON OFF)
		-DUSE_BZIP2=OFF
		-DUSE_GZIP=OFF
		-DWITH_DBUS=$(usex dbus ON OFF)
	)
	cmake_src_configure
}
