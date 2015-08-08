# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Meta package for a suite of sparse matrix tools"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/SuiteSparse/"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cuda doc metis tbb lapack"
DEPEND=""
RDEPEND="
	>=sci-libs/suitesparseconfig-${PV}
	>=sci-libs/amd-2.3.1[doc?]
	>=sci-libs/btf-1.2.0
	>=sci-libs/camd-2.3.1[doc?]
	>=sci-libs/ccolamd-2.8.0
	>=sci-libs/cholmod-2.1.2[cuda?,doc?,metis?,lapack?]
	>=sci-libs/colamd-2.3.1
	>=sci-libs/cxsparse-3.1.2
	>=sci-libs/klu-1.2.0[doc?]
	>=sci-libs/ldl-2.0.4[doc?]
	>=sci-libs/spqr-1.3.1[doc?,metis?,tbb?]
	>=sci-libs/umfpack-5.6.2[doc?,cholmod]"
