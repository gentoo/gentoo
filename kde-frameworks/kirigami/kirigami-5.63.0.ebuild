# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_EXAMPLES="true"
KDE_QTHELP="false"
KDE_TEST="true"
KMNAME="${PN}2"
inherit kde5

DESCRIPTION="Lightweight user interface framework for mobile and convergent applications"
HOMEPAGE="https://techbase.kde.org/Kirigami"
EGIT_REPO_URI="${EGIT_REPO_URI/${PN}2/${PN}}"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

# drop qtgui subslot operator when QT_MINIMAL >= 5.14.0
BDEPEND="
	$(add_qt_dep linguist-tools)
"
DEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgraphicaleffects)
	$(add_qt_dep qtgui '' '' '5=')
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtquickcontrols2)
	$(add_qt_dep qtsvg)
"
RDEPEND="${DEPEND}"

# requires package to already be installed
RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
	)

	kde5_src_configure
}
