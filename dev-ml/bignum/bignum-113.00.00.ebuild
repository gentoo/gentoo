# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit oasis

DESCRIPTION="Core-flavoured wrapper around zarith's arbitrary-precision rationals"
HOMEPAGE="http://janestreet.github.io/"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-ml/bin-prot:=
	dev-ml/comparelib:=
	dev-ml/core_kernel:=
	dev-ml/pa_bench:=
	dev-ml/pa_test:=
	dev-ml/pa_ounit:=
	dev-ml/sexplib:=
	dev-ml/typerep:=
	dev-ml/zarith:=
"
RDEPEND="${DEPEND}"
