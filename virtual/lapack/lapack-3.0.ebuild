# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/lapack/lapack-3.0.ebuild,v 1.4 2012/12/13 16:52:56 jlec Exp $

DESCRIPTION="Virtual for Linear Algebra Package FORTRAN 77 (LAPACK) implementation"
HOMEPAGE=""
SRC_URI=""
LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
RDEPEND="|| (
		sci-libs/lapack-reference
		>=sci-libs/mkl-9.1.023
		>=sci-libs/acml-3.6
	)"
DEPEND=""
