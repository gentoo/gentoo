# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Repackage the OCaml compiler libs so they do not expose everything at toplevel"
HOMEPAGE="https://github.com/janestreet/ocaml-compiler-libs"
SRC_URI="https://github.com/janestreet/ocaml-compiler-libs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 arm arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"
