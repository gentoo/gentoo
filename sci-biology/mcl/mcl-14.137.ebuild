# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="${PN}-${PV/./-}"

DESCRIPTION="A Markov Cluster Algorithm implementation"
HOMEPAGE="http://micans.org/mcl/"
SRC_URI="http://micans.org/mcl/src/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+blast"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-fix-declarations.patch
	"${FILESDIR}"/${P}-fix-autotools.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable blast)
}
