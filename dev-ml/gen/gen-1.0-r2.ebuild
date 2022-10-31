# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Iterators for OCaml, both restartable and consumable"
HOMEPAGE="https://github.com/c-cube/gen/"
SRC_URI="https://github.com/c-cube/gen/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"
RESTRICT="test"  # tests fail  > unused-open

RDEPEND="
	>=dev-lang/ocaml-4.07:=[ocamlopt?]
	dev-ml/dune-configurator:=
"
DEPEND="${RDEPEND}"
# BDEPEND="test? ( dev-ml/qtest )"
