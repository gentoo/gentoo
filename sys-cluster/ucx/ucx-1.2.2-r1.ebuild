# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Unified Communication X"
HOMEPAGE="https://www.openucx.org"
SRC_URI="https://github.com/openucx/ucx/releases/download/v${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+numa +openmp"

RDEPEND="
	numa? ( sys-process/numactl )
"

src_prepare() {
	default
	sed \
		-e '/BASE_CFLAGS=/s:=".*":=:g' \
		-i config/m4/compiler.m4 || die
	eautoreconf
}

src_configure() {
	BASE_CFLAGS="" \
	econf \
		--disable-compiler-opt \
		$(use_enable numa) \
		$(use_enable openmp)
}
