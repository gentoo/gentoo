# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ECM_KDEINSTALLDIRS="false"
KDE_TEST="optional"
KDE_EXAMPLES="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Library for writing accessibility clients such as screen readers"
HOMEPAGE="https://accessibility.kde.org/ https://cgit.kde.org/libqaccessibilityclient.git"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"

# tests require DBus
RESTRICT+=" test"

PATCHES=( "${FILESDIR}/${P}-tests.patch" )
