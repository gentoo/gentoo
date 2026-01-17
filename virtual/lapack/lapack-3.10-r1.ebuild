# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Virtual for Linear Algebra Package FORTRAN 77 (LAPACK) implementation"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"
IUSE="eselect-ldso flexiblas index64"
REQUIRED_USE="?? ( eselect-ldso flexiblas )"

RDEPEND="
	flexiblas? (
		sci-libs/flexiblas[system-blas(-),index64(-)?]
		sci-libs/blas-lapack-aux-wrapper[index64?]
	)
	!flexiblas? (
		>=sci-libs/lapack-3.10.0[eselect-ldso(-)?,-flexiblas(-),index64(-)?]
		eselect-ldso? (
			|| (
				>=sci-libs/lapack-3.10.0[eselect-ldso(-)]
				sci-libs/openblas[eselect-ldso(-)]
			)
		)
	)
"
