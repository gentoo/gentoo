# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit oasis

DESCRIPTION="Camlp4 syntax extension that derives comparison functions from type representations"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV}/individual/${P}.tar.gz
	https://dev.gentoo.org/~aballier/distfiles/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-ml/type-conv-109.20.00:=
	dev-ml/camlp4:="
RDEPEND="${DEPEND}"

DOCS=( "README.txt" )
