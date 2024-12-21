# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Generic C++ template library for sparse, dense and skyline matrices"
HOMEPAGE="https://getfem.org/gmm.html"
SRC_URI="mirror://nongnu/getfem/stable/${P}.tar.gz"

LICENSE="|| ( LGPL-3 LGPL-3-with-linking-exception )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

PATCHES=( "${FILESDIR}"/${PN}-5.4.2_do-not-overoptimize.patch )
