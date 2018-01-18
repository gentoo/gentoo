# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_PN="${PN#gimp-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Suite of GIMP plugins for texture synthesis"
HOMEPAGE="https://github.com/bootchk/resynthesizer"
SRC_URI="https://github.com/bootchk/resynthesizer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-gfx/gimp"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoreconf
}
