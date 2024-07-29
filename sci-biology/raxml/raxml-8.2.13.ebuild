# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Sequential, Parallel & Distributed Inference of Large Phylogenetic Trees"
HOMEPAGE="https://github.com/stamatak/standard-RAxML"
SRC_URI="https://github.com/stamatak/standard-RAxML/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/standard-RAxML-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse3 +threads"

# mpi is not supported in version 7.2.2. mpi is enabled by adding -DPARALLEL to CFLAGS
PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	use cpu_flags_x86_sse3 &&
		append-cppflags -D__SIM_SSE3 &&
		append-cflags -msse3
	use threads &&
		append-cppflags -D_USE_PTHREADS &&
		append-cflags -pthread

	tc-export CC
}

src_compile() {
	emake -f Makefile.gcc
}

src_install() {
	dobin raxmlHPC
}
