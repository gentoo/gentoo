# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Library to perform analysis on package repositories"
HOMEPAGE="http://www.mancoosi.org/software/ https://gforge.inria.fr/projects/dose"
SRC_URI="https://gitlab.com/irill/${PN}/-/archive/${PV}/${P}.tar.bz2"
S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="+ocamlopt"

BDEPEND="
	dev-ml/findlib
	dev-ml/ocamlbuild
"
RDEPEND="
	>=dev-lang/ocaml-4.03:=[ocamlopt=]
	dev-ml/ocaml-base64:=[ocamlopt=]
	>=dev-ml/cudf-0.7:=[ocamlopt=]
	>=dev-ml/extlib-1.7.8:=[ocamlopt=]
	>=dev-ml/ocamlgraph-2.0.0:=[ocamlopt=]
	>=dev-ml/re-1.2.2:=[ocamlopt=]
	dev-ml/parmap:=[ocamlopt=]
	>=dev-ml/camlzip-1.08:=[ocamlopt=]
	>=dev-ml/camlbz2-0.7.0:=
	dev-ml/ocaml-expat:=[ocamlopt=]
	dev-ml/xml-light:=[ocamlopt=]
	app-arch/rpm
"
DEPEND="${RDEPEND}"

# missing test data
RESTRICT="test"

QA_FLAGS_IGNORED='.*'
