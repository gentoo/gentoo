# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Virtual for FORTRAN 77 BLAS implementation"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="eselect-ldso"

RDEPEND="
	!eselect-ldso? ( >=sci-libs/lapack-3.8.0[-eselect-ldso] )
	eselect-ldso? ( || (
		>=sci-libs/lapack-3.8.0[eselect-ldso]
		sci-libs/blis[eselect-ldso] ) )
"
DEPEND="${RDEPEND}"
