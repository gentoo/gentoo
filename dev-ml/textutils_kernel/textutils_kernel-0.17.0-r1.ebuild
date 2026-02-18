# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Text output utilities"
HOMEPAGE="https://github.com/janestreet/textutils_kernel"
SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

DEPEND="
	>=dev-lang/ocaml-5
	dev-ml/core:${SLOT}[ocamlopt?]
	dev-ml/ppx_jane:${SLOT}[ocamlopt?]
	>=dev-ml/uutf-1.0.2:=[ocamlopt?]
"
RDEPEND="${DEPEND}"
