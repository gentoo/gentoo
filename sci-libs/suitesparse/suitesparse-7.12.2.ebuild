# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Metapackage for a suite of sparse matrix tools"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"

LICENSE="metapackage"
SLOT="0"

KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="cuda doc openmp partition"
PDEPEND="
	~sci-libs/suitesparseconfig-${PV}[cuda?,openmp?]
	~sci-libs/amd-3.3.4[doc?]
	~sci-libs/btf-2.3.3
	~sci-libs/camd-3.3.5[doc?]
	~sci-libs/ccolamd-3.3.5
	~sci-libs/cholmod-5.3.4[cuda?,doc?,openmp?,partition?]
	~sci-libs/colamd-3.3.5
	~sci-libs/cxsparse-4.4.2
	~sci-libs/klu-2.3.6[doc?]
	~sci-libs/ldl-3.3.3[doc?]
	~sci-libs/spqr-4.3.6[cuda?,doc?]
	~sci-libs/umfpack-6.3.7[doc?,openmp?]
"
