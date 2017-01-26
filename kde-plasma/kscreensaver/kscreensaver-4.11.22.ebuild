# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="KDE Plasma screensaver framework"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	kde-plasma/kcheckpass:4
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.5.95-nsfw.patch"
)
