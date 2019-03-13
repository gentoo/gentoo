# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_TESTS=1
OASIS_BUILD_DOCS=1

inherit oasis

MY_P=${P/_/\~}
DESCRIPTION="Tool to integrate a configure, build and install system in OCaml project"
HOMEPAGE="http://oasis.forge.ocamlcore.org/index.php"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1694/${MY_P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-ml/ocaml-data-notation-0.0.11:=
	dev-ml/ocamlbuild:=[ocamlopt]
	dev-ml/camlp4:=
"
DEPEND="${RDEPEND}
	>=dev-ml/findlib-1.3.1
	dev-ml/ocamlify
	dev-ml/ocamlmod
	!<sci-chemistry/oasis-4.0-r3
	test? (
		>=dev-ml/ocaml-fileutils-0.4.2
		>=dev-ml/ounit-2.0.0
		>=dev-ml/ocaml-expect-0.0.4
		dev-ml/pcre-ocaml
		dev-ml/extlib
	)"

STRIP_MASK="*/bin/*"
S="${WORKDIR}/${MY_P}"
DOCS=( "README.md" "TODO.txt" "AUTHORS.md" "CHANGES.txt" )
