# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit rpm eutils

# Binary only distribution
QA_PREBUILT="*"

DESCRIPTION="Project collaboration and tracking software for oDesk.com"
HOMEPAGE="https://www.odesk.com/"
SRC_URI="amd64? ( https://www.odesk.com/downloads/linux/beta/${P}.x86_64.rpm )
		 x86? ( https://www.odesk.com/downloads/linux/beta/${P}.i386.rpm )
"

LICENSE="ODESK"
SLOT="0"
KEYWORDS="amd64 x86"

S=${WORKDIR}

RDEPEND="
|| ( dev-qt/qtphonon:4 media-libs/phonon[qt4] )
>=dev-libs/glib-2
app-arch/bzip2
dev-libs/libxml2
dev-qt/qtcore:4[ssl]
dev-qt/qtdbus:4
dev-qt/qtdeclarative:4
dev-qt/qtgui:4
dev-qt/qtopengl:4
dev-qt/qtscript:4
dev-qt/qtsql:4
dev-qt/qtsvg:4
dev-qt/qtxmlpatterns:4
media-libs/glu
media-libs/mesa
sys-libs/glibc
x11-libs/libX11
x11-libs/libXScrnSaver
x11-libs/libXext
x11-libs/libXi
"

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.6.1_desktop_file.patch"
}

src_install() {
	into /opt
	dobin usr/bin/odeskteam-qt4

	domenu usr/share/applications/odeskteam.desktop

	doicon usr/share/pixmaps/odeskteam.png
}
