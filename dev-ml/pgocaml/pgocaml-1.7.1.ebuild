# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/pgocaml/pgocaml-1.7.1.ebuild,v 1.1 2013/07/22 01:10:48 aballier Exp $

EAPI=5

inherit oasis

DESCRIPTION="PG'OCaml is a set of OCaml bindings for the PostgreSQL database"
HOMEPAGE="http://pgocaml.forge.ocamlcore.org/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1099/${P}.tgz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc batteries"

DEPEND="dev-ml/calendar:=
	>=dev-ml/batteries-2:=
	dev-ml/csv:=
	dev-ml/pcre-ocaml:="
RDEPEND="${DEPEND}"

DOCS=( "README.txt" "CHANGELOG.txt"
	"doc/BUGS.txt" "doc/CONTRIBUTORS.txt"
	"doc/HOW_IT_WORKS.txt" "doc/PROFILING.txt"
	)
