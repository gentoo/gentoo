# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="S-expression parsing library"
HOMEPAGE="https://github.com/janestreet/parsexp"
SRC_URI="https://github.com/janestreet/parsexp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-5
	dev-ml/sexplib0:${SLOT}[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
