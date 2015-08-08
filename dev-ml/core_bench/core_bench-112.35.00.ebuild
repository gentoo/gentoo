# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit oasis

DESCRIPTION="Micro-benchmarking library for OCaml"
HOMEPAGE="https://ocaml.janestreet.com/"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-ml/sexplib:=
	dev-ml/textutils:=
	dev-ml/pa_ounit:=
	dev-ml/core:=
	dev-ml/fieldslib:=
	dev-ml/comparelib:=
	dev-ml/camlp4:=
"
DEPEND="${RDEPEND}"

DOCS=( README.md )
