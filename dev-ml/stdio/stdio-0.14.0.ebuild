# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Standard IO Library for OCaml"
HOMEPAGE="https://github.com/janestreet/stdio"
SRC_URI="https://github.com/janestreet/stdio/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 x86"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-ml/base-0.11.0:=
		dev-ml/sexplib0:="
DEPEND="${RDEPEND}"
