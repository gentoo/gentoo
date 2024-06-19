# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME=bz2
inherit dune

DESCRIPTION="OCaml bindings for libbz (AKA, bzip2)"
HOMEPAGE="https://gitlab.com/irill/camlbz2"
SRC_URI="https://gitlab.com/irill/camlbz2/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

DEPEND="app-arch/bzip2"
RDEPEND="${DEPEND}"
