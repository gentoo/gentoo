# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit oasis

DESCRIPTION="Text output utilities"
HOMEPAGE="https://ocaml.janestreet.com/"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-lang/ocaml-4.02[ocamlopt?]
	>=dev-ml/core-109.24.00:=
	>=dev-ml/pa_ounit-109.18.00:=
	>=dev-ml/sexplib-109.20.00:=
	dev-ml/camlp4:=
"
DEPEND="${RDEPEND}"
