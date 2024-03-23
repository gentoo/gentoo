# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Exposes an API to create and manage standard (ISO 13249 aka SQL/MM) topologies"
HOMEPAGE="https://git.osgeo.org/gitea/rttopo/librttopo"
SRC_URI="https://git.osgeo.org/gitea/rttopo/librttopo/archive/${P}.tar.gz"
S="${WORKDIR}/librttopo"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="sci-libs/geos"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
