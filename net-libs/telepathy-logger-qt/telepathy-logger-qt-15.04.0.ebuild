# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit kde5 python-any-r1

DESCRIPTION="Qt bindings for the Telepathy logger"
HOMEPAGE="https://projects.kde.org/projects/extragear/network/telepathy/telepathy-logger-qt"

if [[ ${KDE_BUILD_TYPE} = live ]]; then
	KEYWORDS=""
else
	SRC_URI="mirror://kde/stable/telepathy-logger-qt/${PV%.*}/src/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1"
IUSE=""

RDEPEND="
	$(add_qt_dep qtdbus)
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	net-im/telepathy-logger
	net-libs/telepathy-glib
	net-libs/telepathy-qt[qt5]
	sys-apps/dbus
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
"
