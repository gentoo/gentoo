# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="An [option]-like type that incurs no allocation"
HOMEPAGE="https://github.com/janestreet/uopt"
SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-5
	dev-ml/base:${SLOT}[ocamlopt?]
	dev-ml/ppx_jane:${SLOT}[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
