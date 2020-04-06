# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Metapackage for a suite of sparse matrix tools"
HOMEPAGE="http://faculty.cse.tamu.edu/davis/suitesparse.html"

LICENSE="metapackage"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cuda doc lapack partition tbb"
DEPEND=""
RDEPEND="
	~sci-libs/suitesparseconfig-${PV}
	~sci-libs/amd-2.4.6[doc?]
	~sci-libs/btf-1.2.6
	~sci-libs/camd-2.4.6[doc?]
	~sci-libs/ccolamd-2.9.6
	~sci-libs/cholmod-3.0.13[cuda?,doc?,partition?,lapack?]
	~sci-libs/colamd-2.9.6
	~sci-libs/cxsparse-3.2.0
	~sci-libs/klu-1.3.9[doc?]
	~sci-libs/ldl-2.2.6[doc?]
	~sci-libs/spqr-2.0.9[doc?,partition?,tbb?]
	~sci-libs/umfpack-5.7.9[doc?,cholmod]"
