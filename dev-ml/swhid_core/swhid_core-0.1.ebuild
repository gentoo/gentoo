# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit dune

DESCRIPTION="OCaml library to work with swhids"
HOMEPAGE="https://github.com/ocamlpro/swhid_core"
SRC_URI="https://github.com/OCamlPro/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

IUSE="+ocamlopt"
