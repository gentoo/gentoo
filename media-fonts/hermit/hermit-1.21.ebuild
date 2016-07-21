# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

DESCRIPTION="A monospace font designed to be clear, pragmatic and very readable"
HOMEPAGE="http://pcaro.es/p/hermit/"
SRC_URI="http://pcaro.es/d/otf-${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}
FONT_SUFFIX="otf"
