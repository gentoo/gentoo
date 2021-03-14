# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Library for creating runtime representation of OCaml types"
HOMEPAGE="https://github.com/janestreet/typerep"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt"

DEPEND="dev-ml/base:="
RDEPEND="${DEPEND}"
