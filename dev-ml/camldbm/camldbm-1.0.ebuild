# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit base

DESCRIPTION="OCaml binding to the NDBM/GDBM Unix databases"
HOMEPAGE="http://forge.ocamlcore.org/projects/camldbm/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/728/${P}.tgz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~ppc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="|| ( >=sys-libs/gdbm-1.9.1-r2[berkdb] <sys-libs/gdbm-1.9.1-r2 )
	>=dev-lang/ocaml-3.12:=[ocamlopt]
	!<dev-lang/ocaml-4[gdbm]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/hasgotfix.patch" "${FILESDIR}/include_fix.patch" )

src_install() {
	dodir "$(ocamlc -where)/stublibs" # required and makefile does not create it
	emake LIBDIR="${D}/$(ocamlc -where)" install
	dodoc README Changelog
}
