# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/gidole/gidole-2.0.2.ebuild,v 1.2 2015/04/28 09:57:18 yngwin Exp $

EAPI=5
inherit font

DESCRIPTION="Open source modern DIN fonts"
HOMEPAGE="http://gidole.github.io/"
SRC_URI="http://dev.gentoo.org/~yngwin/distfiles/${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND="app-arch/unzip"
S="${WORKDIR}/GidoleFont"
FONT_SUFFIX="otf ttf"
