# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="es"
KDE_DOC_DIRS="doc/${PN}"
KDE_HANDBOOK=optional
inherit kde4-base

DESCRIPTION="MUD client for KDE"
HOMEPAGE="http://www.kmuddy.com/"
SRC_URI="http://www.kmuddy.com/releases/stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

DOC=( AUTHORS README CHANGELOG Scripting-HOWTO TODO DESIGN )

PATCHES=(
	"${FILESDIR}"/${P}-{gcc,kde}45.patch
	"${FILESDIR}"/${P}-underlinking.patch
	"${FILESDIR}"/${P}-tempnam.patch
	"${FILESDIR}"/${P}-desktopvalidation.patch
)
src_configure() {
	# not in portage yet
	local mycmakeargs=(
		-DWITH_MXP=OFF
	)
	kde4-base_src_configure
}
