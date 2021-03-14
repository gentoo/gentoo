# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Convert OCaml parsetrees between different major versions"
HOMEPAGE="https://github.com/let-def/ocaml-migrate-parsetree"
SRC_URI="https://github.com/let-def/ocaml-migrate-parsetree/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-ml/cinaps )"
