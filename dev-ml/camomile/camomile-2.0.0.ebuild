# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Camomile is a comprehensive Unicode library for ocaml"
HOMEPAGE="https://github.com/savonet/Camomile"
SRC_URI="https://github.com/savonet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P^}"

LICENSE="LGPL-2"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
IUSE="+ocamlopt"

# Unbound module errors
RESTRICT="test"

RDEPEND="
	dev-ml/dune-site:=
	dev-ml/camlp-streams:=
"
DEPEND="${RDEPEND}"
