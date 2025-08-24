# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="The OCaml graphics library"
HOMEPAGE="https://github.com/ocaml/graphics"
SRC_URI="https://github.com/ocaml/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="dev-ml/dune-configurator:=[ocamlopt?]
	x11-libs/libXft
	x11-libs/libX11:="
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

IUSE="+ocamlopt"
