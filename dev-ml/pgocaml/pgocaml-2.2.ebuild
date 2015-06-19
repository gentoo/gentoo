# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/pgocaml/pgocaml-2.2.ebuild,v 1.1 2015/04/10 15:30:49 aballier Exp $

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="PG'OCaml is a set of OCaml bindings for the PostgreSQL database"
HOMEPAGE="http://pgocaml.forge.ocamlcore.org/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1506/${P}.tgz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="dev-ml/calendar:=
	dev-ml/csv:=
	dev-ml/pcre-ocaml:=
	dev-ml/camlp4:="
RDEPEND="${DEPEND}"

DOCS=( "README.txt" "CHANGELOG.txt"
	"doc/BUGS.txt" "doc/CONTRIBUTORS.txt"
	"doc/HOW_IT_WORKS.txt" "doc/PROFILING.txt"
	)
