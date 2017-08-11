# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="Generic C++ template library for sparse, dense and skyline matrices"
SRC_URI="https://download.gna.org/getfem/stable/${P}.tar.gz"
HOMEPAGE="https://www-gmm.insa-toulouse.fr/getfem/"

LICENSE="|| ( LGPL-3 LGPL-3-with-linking-exception )"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

src_configure() {
	# required for tests, #612294
	append-cxxflags -std=c++14

	default
}
