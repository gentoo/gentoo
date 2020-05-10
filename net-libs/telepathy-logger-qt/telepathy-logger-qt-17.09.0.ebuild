# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
QTMIN=5.12.3
inherit ecm kde.org python-any-r1

DESCRIPTION="Qt bindings for the Telepathy logger"
HOMEPAGE="https://cgit.kde.org/telepathy-logger-qt.git"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/telepathy-logger-qt/${PV%.*}/src/${P}.tar.xz"
	KEYWORDS="amd64 arm64 x86"
fi

LICENSE="LGPL-2.1"
SLOT="5"
IUSE=""

BDEPEND="${PYTHON_DEPS}"
DEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	>=dev-qt/qtdbus-${QTMIN}:5
	net-im/telepathy-logger
	net-libs/telepathy-glib
	net-libs/telepathy-qt[qt5(+)]
	sys-apps/dbus
"
RDEPEND="${DEPEND}"
