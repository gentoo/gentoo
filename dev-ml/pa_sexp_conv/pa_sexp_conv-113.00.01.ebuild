# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit oasis

DESCRIPTION="Deprecated camlp4 syntax extension for sexplib."
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="https://github.com/janestreet/pa_sexp_conv/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-ml/type-conv:=
	>=dev-ml/sexplib-113.24:=
	dev-ml/camlp4:=
"
RDEPEND="${DEPEND}"
DOCS=( README.md )
