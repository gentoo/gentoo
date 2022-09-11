# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A binary data serialization format inspired by JSON for OCaml"
HOMEPAGE="https://github.com/ocaml-community/biniou/"
SRC_URI="https://github.com/ocaml-community/biniou/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.02.3:=[ocamlopt?]
	dev-ml/camlp-streams:=[ocamlopt?]
	dev-ml/easy-format:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
