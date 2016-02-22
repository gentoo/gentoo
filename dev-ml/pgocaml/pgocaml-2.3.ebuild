# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="PG'OCaml is a set of OCaml bindings for the PostgreSQL database"
HOMEPAGE="http://pgocaml.forge.ocamlcore.org/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1597/${P}.tgz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="camlp4 doc"

DEPEND="dev-ml/calendar:=
	dev-ml/csv:=
	dev-ml/pcre-ocaml:=
	camlp4? ( dev-ml/camlp4:= )"
RDEPEND="${DEPEND}"

DOCS=( "README.md" "CHANGELOG.txt"
	"doc/BUGS.txt" "doc/CONTRIBUTORS.txt"
	"doc/HOW_IT_WORKS.txt" "doc/PROFILING.txt"
	)

src_configure() {
	oasis_configure_opts="$(use_enable camlp4 p4)" oasis_src_configure
}
