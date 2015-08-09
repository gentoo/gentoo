# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font

MYPN=TeX-fonts-linux

DESCRIPTION="Raster fonts for jsmath"
HOMEPAGE="http://www.math.union.edu/~dpvc/jsMath/"
SRC_URI="http://www.math.union.edu/~dpvc/jsMath/download/${MYPN}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MYPN}"
FONT_S="${S}"
FONT_PN="jsMath"
FONT_SUFFIX="ttf"
