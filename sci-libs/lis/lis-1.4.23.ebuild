# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/lis/lis-1.4.23.ebuild,v 1.2 2015/01/29 23:02:59 mgorny Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes
AUTOTOOLS_IN_SOURCE_BUILD=yes

inherit autotools-utils fortran-2

DESCRIPTION="Library of Iterative Solvers for Linear Systems"
HOMEPAGE="http://www.ssisc.org/lis/index.en.html"
SRC_URI="http://www.ssisc.org/lis/dl/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc cpu_flags_x86_fma3 cpu_flags_x86_fma4 fortran mpi openmp quad saamg cpu_flags_x86_sse2 static-libs"

RDEPEND="mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.4.23-autotools.patch )

pkg_setup() {
	if use openmp; then
		[[ $(tc-getCC)$ == *gcc* ]] && ! tc-has-openmp && \
			die "You have openmp enabled but your current gcc does not support it"
		export FORTRAN_NEED_OPENMP=1
	fi
	use fortran && fortran-2_pkg_setup
}

src_configure() {
	local myeconfargs=(
		$(use_enable fortran)
		$(use_enable openmp omp)
		$(use_enable quad)
		$(use_enable "cpu_flags_x86_fma$(usex cpu_flags_x86_fma3 3 4)" fma)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable saamg)
		$(use_enable mpi)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc doc/*.pdf
}
