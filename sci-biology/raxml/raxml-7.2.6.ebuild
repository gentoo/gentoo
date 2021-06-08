# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Sequential, Parallel & Distributed Inference of Large Phylogenetic Trees"
HOMEPAGE="http://wwwkramer.in.tum.de/exelixis/software.html"
SRC_URI="http://wwwkramer.in.tum.de/exelixis/software/RAxML-${PV}.tar.bz2"
S="${WORKDIR}/RAxML-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse3 +threads"
REQUIRED_USE="cpu_flags_x86_sse3"

# mpi is not supported in version 7.2.2. mpi is enabled by adding -DPARALLEL to CFLAGS
PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	use cpu_flags_x86_sse3 && append-cppflags -D__SIM_SSE3
	use threads && \
		append-cppflags -D_USE_PTHREADS && \
		append-libs -pthread

	tc-export CC
}

src_compile() {
	emake -f Makefile.gcc
}

src_install() {
	dobin raxmlHPC
}
