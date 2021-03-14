# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Trivial metaprogramming tool"
HOMEPAGE="https://github.com/ocaml-ppx/cinaps"
SRC_URI="https://github.com/ocaml-ppx/cinaps/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-ml/findlib:=
	dev-ml/re:=
"
RDEPEND="${DEPEND}"
BDEPEND=""
DEPEND="${DEPEND}
	test? (
		dev-ml/ppx_jane
		)
"
