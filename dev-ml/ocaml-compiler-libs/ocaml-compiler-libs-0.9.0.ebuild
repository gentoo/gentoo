# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit opam

DESCRIPTION="Repackage the OCaml compiler libs so they do not expose everything at toplevel"
HOMEPAGE="https://github.com/janestreet/ocaml-compiler-libs"
SRC_URI="https://github.com/janestreet/ocaml-compiler-libs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-ml/jbuilder"
