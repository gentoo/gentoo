# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="An extremely memory-efficient hash_map implementation"
HOMEPAGE="https://github.com/sparsehash/sparsehash"
SRC_URI="https://github.com/sparsehash/sparsehash/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/${PN}-${P}"

PATCHES=( "${FILESDIR}"/${PN}-2.0.3-fix-buildsystem.patch )

src_prepare() {
	default
	eautoreconf
}
