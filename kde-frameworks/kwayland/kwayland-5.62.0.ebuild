# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
inherit kde5

DESCRIPTION="Qt-style client and server library wrapper for Wayland libraries"
HOMEPAGE="https://cgit.kde.org/kwayland.git"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtgui 'egl')
	>=dev-libs/wayland-1.15.0
	media-libs/mesa[egl]
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/wayland-protocols-1.15
"
RDEPEND="${COMMON_DEPEND}
	$(add_qt_dep qtwayland)
"

# All failing, I guess we need a virtual wayland server
RESTRICT+=" test"
