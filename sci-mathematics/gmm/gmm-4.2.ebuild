# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/gmm/gmm-4.2.ebuild,v 1.5 2012/12/23 19:34:01 maekke Exp $

EAPI=4

DESCRIPTION="Generic C++ template library for sparse, dense and skyline matrices"
SRC_URI="http://download.gna.org/getfem/stable/${P}.tar.gz"
HOMEPAGE="http://www-gmm.insa-toulouse.fr/getfem/"

LICENSE="|| ( LGPL-3 LGPL-3-with-linking-exception )"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

DOCS=( AUTHORS )
