# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="forceoptional-recursive"
QT_MINIMAL="5.9"
inherit kde5

DESCRIPTION="A mail client by KDE"
HOMEPAGE="https://kube.kde.org/"
SRC_URI="https://github.com/KDE/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

RDEPEND="
	$(add_frameworks_dep breeze-icons)
	$(add_frameworks_dep kcodecs)
	$(add_kdeapps_dep kcontacts)
	$(add_kdeapps_dep kmime)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtquickcontrols)
	$(add_qt_dep qtquickcontrols2)
	$(add_qt_dep qttest)
	$(add_qt_dep qtwebengine)
	$(add_qt_dep qtwidgets)
	>=app-crypt/gpgme-1.7.1:=[cxx,qt5]
	dev-libs/kasync
	>=dev-libs/sink-0.3.0
"
DEPEND="${RDEPEND}
	test? ( $(add_qt_dep qttest) )
"

RESTRICT+=" test"

src_prepare() {
	kde5_src_prepare

	if ! use test; then
		sed \
			-e "/Qt5::Test/s/^/#DISABLED/" \
			-e "/set(BUILD_TESTING ON)/s/^/#DISABLED /" \
			-e "/domain\/modeltest.cpp/s/^/#DISABLED /" \
			-i framework/src/CMakeLists.txt || die
	fi
}
