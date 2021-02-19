# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Parsing and printing of S-expressions in Canonical form"
HOMEPAGE="https://github.com/ocaml-dune/csexp"
SRC_URI="https://github.com/ocaml-dune/csexp/releases/download/${PV}/${P}.tbz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-ml/result-1.5:=[ocamlopt=]
"
RDEPEND="${DEPEND}"
BDEPEND=""
DEPEND="${DEPEND}
	test? ( dev-ml/ppx_expect )
"
