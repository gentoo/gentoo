# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Cross-platform application development framework (metapackage)"
HOMEPAGE="https://www.qt.io/"

LICENSE="metapackage"
SLOT="4"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+dbus examples kde openvg +qt3support +webkit"

DEPEND=""
RDEPEND="
	>=dev-qt/assistant-${PV}:4
	>=dev-qt/designer-${PV}:4
	>=dev-qt/linguist-${PV}:4
	>=dev-qt/pixeltool-${PV}:4
	dbus? ( >=dev-qt/qdbusviewer-${PV}:4 )
	qt3support? ( >=dev-qt/qt3support-${PV}:4 )
	>=dev-qt/qtbearer-${PV}:4
	>=dev-qt/qtcore-${PV}:4
	dbus? ( >=dev-qt/qtdbus-${PV}:4 )
	>=dev-qt/qtdeclarative-${PV}:4
	examples? ( >=dev-qt/qtdemo-${PV}:4 )
	>=dev-qt/qtgui-${PV}:4
	>=dev-qt/qthelp-${PV}:4
	>=dev-qt/qtmultimedia-${PV}:4
	>=dev-qt/qtopengl-${PV}:4
	openvg? ( >=dev-qt/qtopenvg-${PV}:4 )
	kde? ( media-libs/phonon[qt4] )
	!kde? ( || ( >=dev-qt/qtphonon-${PV}:4 media-libs/phonon[qt4] ) )
	>=dev-qt/qtscript-${PV}:4
	>=dev-qt/qtsql-${PV}:4
	>=dev-qt/qtsvg-${PV}:4
	>=dev-qt/qttest-${PV}:4
	webkit? ( >=dev-qt/qtwebkit-${PV}:4 )
	>=dev-qt/qtxmlpatterns-${PV}:4
"
