# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_PN=TeX-fonts-linux

DESCRIPTION="Raster fonts for jsmath"
HOMEPAGE="http://www.math.union.edu/~dpvc/jsMath/"
SRC_URI="http://www.math.union.edu/~dpvc/jsMath/download/${MY_PN}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

S="${WORKDIR}/${MY_PN}"

FONT_S="${S}"
FONT_PN="jsMath"
FONT_SUFFIX="ttf"
