# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_AUTODEPS="false"
KDE_DEBUG="false"
KDE_QTHELP="false"
KDE_TEST="true"
KMNAME="oxygen-icons5"
inherit kde5

DESCRIPTION="Oxygen SVG icon theme"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

BDEPEND="
	$(add_frameworks_dep extra-cmake-modules)
	$(add_qt_dep qtcore)
	test? ( app-misc/fdupes )
"
DEPEND="test? ( $(add_qt_dep qttest) )"
RDEPEND="
	!kde-frameworks/oxygen-icons:4
"
