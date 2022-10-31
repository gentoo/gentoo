# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Compatibility package for the standard OCaml iterator type"
HOMEPAGE="https://github.com/c-cube/seq"
SRC_URI="https://github.com/c-cube/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt"

RDEPEND="<dev-lang/ocaml-4.07"
