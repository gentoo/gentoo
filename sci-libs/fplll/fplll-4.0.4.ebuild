# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Different implementations of the floating-point LLL reduction algorithm"
HOMEPAGE="http://perso.ens-lyon.fr/damien.stehle/index.html#software"
SRC_URI="http://perso.ens-lyon.fr/damien.stehle/fplll/lib${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=">=dev-libs/gmp-4.2.0:0
	>=dev-libs/mpfr-2.3.0:0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/lib${P}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	DOCS="AUTHORS ChangeLog NEWS README" default
	dohtml README.html
	prune_libtool_files
}
