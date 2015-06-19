# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qdbusviewer/qdbusviewer-5.4.2.ebuild,v 1.1 2015/06/17 15:19:39 pesa Exp $

EAPI=5
QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Graphical tool that lets you introspect D-Bus objects and messages"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86"
fi

IUSE=""

DEPEND="
	>=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtdbus-${PV}:5
	>=dev-qt/qtgui-${PV}:5
	>=dev-qt/qtwidgets-${PV}:5
	>=dev-qt/qtxml-${PV}:5
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/qdbus/qdbusviewer
)
