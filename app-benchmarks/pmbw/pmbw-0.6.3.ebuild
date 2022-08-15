# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Parallel Memory Bandwidth Measurement / Benchmark Tool"
HOMEPAGE="https://github.com/bingmann/pmbw"
SRC_URI="https://github.com/bingmann/pmbw/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

src_prepare() {
	default
	eautoreconf
}
