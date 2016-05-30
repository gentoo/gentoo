# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

# Upstream names the package PV-rX. We change that to
# PV_pX so we can use portage revisions.
MY_P=${PN}-${PV/_p/-r}

DESCRIPTION="Qt GUI configuration tool for Wine"
HOMEPAGE="http://q4wine.brezblock.org.ua/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dbus debug +ico +iso qt5 +wineappdb"

CDEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsingleapplication[qt5,X]
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		dbus? ( dev-qt/qtdbus:5 )
	)
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtsingleapplication[qt4,X]
		dev-qt/qtsql:4[sqlite]
		dbus? ( dev-qt/qtdbus:4 )
	)
"
DEPEND="${CDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
"
RDEPEND="${CDEPEND}
	app-admin/sudo
	>=sys-apps/which-2.19
	ico? ( >=media-gfx/icoutils-0.26.0 )
	iso? ( sys-fs/fuseiso )
"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	local mycmakeargs=(
		-DQT5=$(usex qt5 ON OFF)
		-DDEBUG=$(usex debug ON OFF)
		-DWITH_ICOUTILS=$(usex ico ON OFF)
		-DWITH_SYSTEM_SINGLEAPP=ON
		-DWITH_WINEAPPDB=$(usex wineappdb ON OFF)
		-DUSE_BZIP2=OFF
		-DUSE_GZIP=OFF
		-DWITH_DBUS=$(usex dbus ON OFF)
	)
	cmake-utils_src_configure
}
