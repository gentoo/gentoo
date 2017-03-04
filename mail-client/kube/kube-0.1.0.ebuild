# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="forceoptional-recursive"
inherit kde5

DESCRIPTION="A mail client by KDE"
HOMEPAGE="https://www.kde.org/applications/games/kubrick/"
SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.xz"
KEYWORDS="~amd64"

RDEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kpackage)
	$(add_kdeapps_dep kmime)
	$(add_kdeapps_dep messagelib)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qttest)
	$(add_qt_dep qtwebengine)
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	>=app-crypt/gpgme-1.7.1:=[cxx,qt5]
	dev-libs/kasync
	dev-libs/sink
"
DEPEND="${RDEPEND}"

RESTRICT+=" test"
