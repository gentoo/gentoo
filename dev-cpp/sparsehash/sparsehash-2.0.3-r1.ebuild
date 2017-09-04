# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="An extremely memory-efficient hash_map implementation"
HOMEPAGE="https://github.com/sparsehash/sparsehash"
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

S=${WORKDIR}/${PN}-${P}

PATCHES=( "${FILESDIR}"/${PN}-2.0.3-fix-buildsystem.patch )

src_prepare() {
	default
	eautoreconf
}
