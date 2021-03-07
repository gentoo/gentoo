# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Unified Communication X"
HOMEPAGE="https://www.openucx.org"

MY_PV=${PV/_/-}
SRC_URI="https://github.com/openucx/ucx/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+numa +openmp"

RDEPEND="
	sys-libs/binutils-libs:=
	numa? ( sys-process/numactl )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	BASE_CFLAGS="" \
	econf \
		--disable-compiler-opt \
		$(use_enable numa) \
		$(use_enable openmp)
}

src_compile() {
	BASE_CFLAGS="" emake
}
