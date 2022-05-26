# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="invoke amd64 instructions (such as clz,popcnt,rdtsc,rdpmc)"
HOMEPAGE="https://github.com/janestreet/ocaml_intrinsics"
SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

DEPEND="
	>=dev-lang/ocaml-4.08
	dev-ml/dune-configurator:=
"
RDEPEND="${DEPEND}"
BDEPEND=""
