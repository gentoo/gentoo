# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_TESTS=1
OASIS_BUILD_DOCS=1

inherit oasis

MY_P=${P/_/\~}
DESCRIPTION="OASIS is a tool to integrate a configure, build and install system in OCaml project"
HOMEPAGE="http://oasis.forge.ocamlcore.org/index.php"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/1475/${MY_P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-ml/ocaml-data-notation-0.0.11:=
	dev-ml/ocamlbuild:=[ocamlopt]"
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
DOCS=( "README.txt" "TODO.txt" "AUTHORS.txt" "CHANGES.txt" )
