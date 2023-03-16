# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Syntax extension for writing in-line tests in ocaml code"
HOMEPAGE="https://github.com/janestreet/ppx_inline_test"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

# https://bugs.gentoo.org/749291#c2
RESTRICT="test"

RDEPEND="
	>=dev-ml/ppxlib-0.29.0:=
	dev-ml/base:=
	dev-ml/time_now:${SLOT}
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-pr39.patch )
