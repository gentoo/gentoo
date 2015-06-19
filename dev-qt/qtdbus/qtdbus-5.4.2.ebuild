# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtdbus/qtdbus-5.4.2.ebuild,v 1.1 2015/06/17 15:20:18 pesa Exp $

EAPI=5
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="The D-Bus module for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}
	>=sys-apps/dbus-1.4.20
	>=sys-libs/zlib-1.2.5
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/dbus
	src/tools/qdbusxml2cpp
	src/tools/qdbuscpp2xml
)

QT5_GENTOO_CONFIG=(
	:dbus
	:dbus-linked:
)

src_configure() {
	local myconf=(
		-dbus-linked
	)
	qt5-build_src_configure
}
