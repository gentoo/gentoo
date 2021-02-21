# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="String type based on Bigarray, for use in I/O and C-bindings"
HOMEPAGE="https://github.com/janestreet/base_bigstring"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-lang/ocaml-4.08.0:=[ocamlopt=]
	dev-ml/base:=
	dev-ml/ppx_jane:=
"
RDEPEND="${DEPEND}"
