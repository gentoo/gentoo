# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font

MY_PN="LinLibertine"
MY_P="${MY_PN}Font-${PV}-2"

DESCRIPTION="OpenType fonts from the Linux Libertine Open Fonts Project"
HOMEPAGE="http://linuxlibertine.sourceforge.net/"
SRC_URI="mirror://sourceforge/linuxlibertine/${MY_P}.tgz"

LICENSE="|| ( GPL-2-with-font-exception OFL )"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

DEPEND=""
RDEPEND="!<x11-libs/pango-1.20.4"

S="${WORKDIR}/${MY_PN}"
FONT_S="${S}/Fonts"
DOCS="Bugs.txt ChangeLog.txt Readme.txt"
FONT_SUFFIX="ttf otf"
