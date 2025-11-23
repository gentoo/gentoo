# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Invoke amd64 instructions (such as clz, popcnt, rdtsc, rdpmc)"
HOMEPAGE="https://github.com/janestreet/ocaml_intrinsics/"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/dune-configurator:=[ocamlopt?]
	dev-ml/ocaml_intrinsics_kernel:${SLOT}[ocamlopt?]
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-lang/ocaml-5
	>=dev-ml/dune-3.11
"
