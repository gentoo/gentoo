# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils qmake-utils
DESCRIPTION="Software used to analyze data from CPAP machines"
HOMEPAGE="https://sleepyhead.jedimark.net/"

# Point to any required sources; these will be automatically downloaded by
# Portage.
SRC_URI="https://gitlab.com/sleepyhead/sleepyhead-code/repository/archive.tar.bz2?ref=1.0.0-beta-2 -> ${P}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND="virtual/opengl
		x11-libs/libX11
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtwebkit:5
		dev-qt/qtserialport:5
		virtual/glu"
RDEPEND="${DEPEND}"

S="${WORKDIR}/sleepyhead-code-1.0.0-beta-2-6b1c125218475720e1bf7c920ed3d10140b0b7c2"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_prepare() {
	eapply_user
	rm configure
	cd "${S}/3rdparty/quazip/"
#	epatch "${FILESDIR}/common_gui.patch"

	sed -i '1i#define OF(x) x' quazip/ioapi.h quazip/unzip.c quazip/unzip.h \
	   quazip/zip.c quazip/zip.h
	cd "${S}"
	eqmake5 SleepyHeadQT.pro
}

src_install() {
	cd "${S}/sleepyhead"
	dobin SleepyHead
	dodoc ../README
	dodoc docs/*
}
