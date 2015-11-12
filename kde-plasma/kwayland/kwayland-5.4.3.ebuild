# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_TEST="true"
inherit kde5

DESCRIPTION="Qt-style client and server library wrapper for Wayland libraries"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/kwayland"

LICENSE="LGPL-2.1"
KEYWORDS=" ~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-libs/wayland-1.3.0
	dev-qt/qtgui:5
	media-libs/mesa[egl]
"
RDEPEND="${DEPEND}"

# All failing, i guess we need a virtual wayland server
RESTRICT="test"
