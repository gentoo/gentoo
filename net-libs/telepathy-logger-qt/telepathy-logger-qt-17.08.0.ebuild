# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit kde5 python-any-r1

DESCRIPTION="Qt bindings for the Telepathy logger"
HOMEPAGE="https://cgit.kde.org/telepathy-logger-qt.git"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/telepathy-logger-qt/${PV%.*}/src/${P}.tar.xz"
	KEYWORDS="amd64 arm64 x86"
fi

LICENSE="LGPL-2.1"
IUSE=""

BDEPEND="${PYTHON_DEPS}"
DEPEND="
	$(add_qt_dep qtdbus)
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	net-im/telepathy-logger
	net-libs/telepathy-glib
	net-libs/telepathy-qt[qt5(+)]
	sys-apps/dbus
"
RDEPEND="${DEPEND}"
