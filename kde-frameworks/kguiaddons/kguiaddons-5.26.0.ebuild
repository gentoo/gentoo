# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework providing assorted high-level user interface components"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

RDEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtx11extras)
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	x11-libs/libxcb
	x11-proto/xproto
"
