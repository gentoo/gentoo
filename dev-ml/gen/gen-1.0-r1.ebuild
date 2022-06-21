# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Iterators for OCaml, both restartable and consumable"
HOMEPAGE="https://github.com/c-cube/gen/"
SRC_URI="https://github.com/c-cube/gen/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"
RESTRICT="test"  # tests fail  > unused-open

DEPEND="
	dev-ml/dune-configurator:=
	dev-ml/seq:="
RDEPEND="${DEPEND}"
# BDEPEND="test? ( dev-ml/qtest )"
