# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Virtual for BLAS C implementation"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"
IUSE="eselect-ldso"

RDEPEND="
	>=sci-libs/lapack-3.8.0[eselect-ldso?]
	eselect-ldso? ( || (
		>=sci-libs/lapack-3.8.0[eselect-ldso]
		sci-libs/openblas[eselect-ldso]
		sci-libs/blis[eselect-ldso] ) )
"
DEPEND="${RDEPEND}"
