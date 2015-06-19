# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/pgocaml/pgocaml-2.1.ebuild,v 1.1 2014/10/30 08:09:19 aballier Exp $

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="PG'OCaml is a set of OCaml bindings for the PostgreSQL database"
HOMEPAGE="http://pgocaml.forge.ocamlcore.org/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1413/${P}.tgz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="dev-ml/calendar:=
	dev-ml/csv:=
	dev-ml/pcre-ocaml:=
	|| ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 )"
RDEPEND="${DEPEND}"

DOCS=( "README.txt" "CHANGELOG.txt"
	"doc/BUGS.txt" "doc/CONTRIBUTORS.txt"
	"doc/HOW_IT_WORKS.txt" "doc/PROFILING.txt"
	)
