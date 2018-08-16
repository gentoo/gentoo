# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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

# drop qtdeclarative subslot operator when QT_MINIMAL >= 5.10.0
RDEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative '' '' '5=')
	$(add_qt_dep qtgraphicaleffects)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtquickcontrols2)
	$(add_qt_dep qtsvg)
"
DEPEND="${RDEPEND}
	$(add_qt_dep linguist-tools)
"

# requires package to already be installed
RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
	)

	kde5_src_configure
}
