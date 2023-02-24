# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Time-zone handling for OCaml"
HOMEPAGE="https://github.com/janestreet/timezone"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="+ocamlopt"

RDEPEND="dev-ml/core:${SLOT}"
DEPEND="${RDEPEND}"
