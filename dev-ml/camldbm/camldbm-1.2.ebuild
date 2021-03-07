# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OCaml binding to the NDBM/GDBM Unix databases"
HOMEPAGE="https://github.com/ocaml/dbm"
SRC_URI="https://github.com/ocaml/dbm/archive/${P}.tar.gz"
S="${WORKDIR}/dbm-${P}"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

DEPEND=">=sys-libs/gdbm-1.9.1-r2[berkdb]
	>=dev-lang/ocaml-3.12:=[ocamlopt]"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED=(
	/usr/'lib.*'/ocaml/dbm.cmxs
	/usr/'lib.*'/ocaml/stublibs/dllcamldbm.so
)

src_install() {
	dodir "$(ocamlc -where)/stublibs" # required and makefile does not create it
	emake LIBDIR="${D}/$(ocamlc -where)" install
}
