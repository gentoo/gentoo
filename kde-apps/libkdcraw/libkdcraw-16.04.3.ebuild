# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_BLOCK_SLOT4="false"
inherit kde5

DESCRIPTION="Digital camera raw image library wrapper"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	$(add_qt_dep qtgui)
	>=media-libs/libraw-0.16:=
"
RDEPEND="${DEPEND}"
