# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Use type-conv to dump OCaml data structure using OCaml data notation"
HOMEPAGE="http://forge.ocamlcore.org/projects/odn"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1310/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-ml/type-conv-108.07.01:=
	dev-ml/camlp4:=
	"
DEPEND="${RDEPEND}
	test? ( >=dev-ml/ounit-2.0.0[ocamlopt?] dev-ml/ocaml-fileutils[ocamlopt?] )"

DOCS=( "README.txt" "AUTHORS.txt" "CHANGES.txt" )
