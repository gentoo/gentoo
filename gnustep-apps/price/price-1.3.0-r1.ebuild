# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2

MY_P=PRICE-${PV}
DESCRIPTION="Precision Raster Image Convolution Engine"
HOMEPAGE="https://price.sourceforge.net/"
SRC_URI="mirror://sourceforge/price/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

KEYWORDS="~amd64 ~ppc x86"
SLOT="0"
LICENSE="GPL-2+"

DEPEND=">=gnustep-base/gnustep-gui-0.13.0"
RDEPEND="${DEPEND}"
