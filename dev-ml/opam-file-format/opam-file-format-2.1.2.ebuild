# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

MY_PV="${PV/_beta/-beta}"
MY_PV="${MY_PV/_rc/-rc}"
S="${WORKDIR}/${PN}-${MY_PV}"

DESCRIPTION="Parser and printer for the opam file syntax"
HOMEPAGE="https://github.com/ocaml/opam-file-format"
SRC_URI="https://github.com/ocaml/opam-file-format/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-ml/alcotest )"
