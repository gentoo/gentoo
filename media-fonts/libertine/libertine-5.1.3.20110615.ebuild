# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/libertine/libertine-5.1.3.20110615.ebuild,v 1.1 2015/02/22 06:41:41 yngwin Exp $

inherit font versionator

MY_DATE=$(get_version_component_range 4)
MY_PV=$(get_version_component_range 1-3)_${MY_DATE:0:4}_${MY_DATE:4:2}_${MY_DATE:6}
MY_P="LinLibertineTTF-${MY_PV}"

DESCRIPTION="OpenType fonts from the Linux Libertine Open Fonts Project"
HOMEPAGE="http://linuxlibertine.sourceforge.net/"
SRC_URI="mirror://sourceforge/linuxlibertine/${MY_P}.tgz"

LICENSE="|| ( GPL-2-with-font-exception OFL )"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ~ppc64 sparc x86"
IUSE=""

DEPEND=""
RDEPEND="!<x11-libs/pango-1.20.4"

S="${WORKDIR}"
FONT_S="${S}"
DOCS="Bugs.txt ChangeLog.txt README"
FONT_SUFFIX="ttf"
