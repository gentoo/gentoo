# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnustep-2

DESCRIPTION="educational application to solve physics problems"
HOMEPAGE="https://www.gnu.org/software/fisicalab"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

S=${WORKDIR}/trunk
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="gnustep-libs/renaissance
	>=sci-libs/gsl-1.10
	>=virtual/gnustep-back-0.31.0"
RDEPEND="${DEPEND}"
