# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit oasis

DESCRIPTION="OCamlify creates OCaml code by including files into strings or string lists"
HOMEPAGE="http://forge.ocamlcore.org/projects/ocamlify"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1209/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}"
IUSE=""

DOCS=( "README.txt" "AUTHORS.txt" )
