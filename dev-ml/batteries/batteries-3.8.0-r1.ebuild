# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A community-maintained standard library extension"
HOMEPAGE="https://github.com/ocaml-batteries-team/batteries-included/"
SRC_URI="https://github.com/ocaml-batteries-team/batteries-included/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/batteries-included-${PV}

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"
RESTRICT="test"

RDEPEND="
	dev-ml/camlp-streams:=[ocamlopt?]
	dev-ml/num:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND="<dev-lang/ocaml-5.3"
