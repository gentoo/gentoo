# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DUNE_PKG_NAME="gsl"
inherit dune

MY_P=${P/-ocaml/}
DESCRIPTION="OCaml bindings for the GSL library (successor of dev-ml/ocamlgsl)"
HOMEPAGE="https://github.com/mmottl/gsl-ocaml"
SRC_URI="https://github.com/mmottl/${PN}/releases/download/${PV}/${MY_P}.tbz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/dune-configurator
	>=sci-libs/gsl-1.19
"
RDEPEND="${DEPEND}
	!dev-ml/ocamlgsl"

# DOCS=( CHANGES.txt README.md NOTES.md TODO.md )
