# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/pomap/pomap-3.0.5.ebuild,v 1.4 2015/02/25 15:35:56 ago Exp $

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Partially Ordered Map ADT for O'Caml"
HOMEPAGE="http://mmottl.github.io/pomap/"
SRC_URI="https://github.com/mmottl/pomap/releases/download/v${PV}/${P}.tar.gz"
LICENSE="LGPL-2.1-with-linking-exception"

DEPEND="|| ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 )"
RDEPEND="${DEPEND}"
SLOT="0/${PV}"
KEYWORDS="amd64 ppc x86"
IUSE="examples"

DOCS=( "AUTHORS.txt" "CHANGES.txt" "README.md" )

src_install() {
	oasis_src_install
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
