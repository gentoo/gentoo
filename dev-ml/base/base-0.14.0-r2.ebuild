# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Standard library for OCaml"
HOMEPAGE="https://github.com/janestreet/base"
SRC_URI="https://github.com/janestreet/base/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 x86"
IUSE="+ocamlopt"

RDEPEND="
	<dev-lang/ocaml-4.12
	>=dev-ml/sexplib0-0.14.0:=[ocamlopt?] <dev-ml/sexplib0-0.15.0:=
	dev-ml/dune-configurator:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
