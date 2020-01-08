# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools python-single-r1

MY_PN="${PN#gimp-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Suite of GIMP plugins for texture synthesis"
HOMEPAGE="https://github.com/bootchk/resynthesizer"
SRC_URI="https://github.com/bootchk/resynthesizer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DEPEND="media-gfx/gimp
	virtual/pkgconfig
	${PYTHON_DEPS}"
RDEPEND="media-gfx/gimp[python,${PYTHON_USEDEP}]
	${PYTHON_DEPS}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoreconf
}
