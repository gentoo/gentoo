# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="Tools for authors of ppx rewriters"
HOMEPAGE="https://github.com/alainfrisch/ppx_tools"
# This is the version used by opam.
# Needed by eliom-5[ppx]
#SRC_URI="http://github.com/diml/ppx_tools/archive/${PN}_${PV}.tar.gz"
#SRC_URI="https://github.com/alainfrisch/ppx_tools/archive/${PN}_${PV}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/ocaml-4.03_beta:="
RDEPEND="${DEPEND}"

#S="${WORKDIR}/${PN}-${PN}_${PV}"

src_compile() {
	emake -j1
}

src_install() {
	findlib_src_install
	dodoc README.md
}
