# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="An extremely memory-efficient hash_map implementation"
HOMEPAGE="https://github.com/sparsehash/sparsehash"
SRC_URI="https://github.com/sparsehash/sparsehash/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"

PATCHES=( "${FILESDIR}"/${PN}-2.0.3-fix-buildsystem.patch )

src_prepare() {
	default
	eautoreconf
}
