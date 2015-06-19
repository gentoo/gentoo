# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/re2/re2-109.55.02.ebuild,v 1.1 2014/01/19 16:06:19 aballier Exp $

EAPI="5"

OASIS_BUILD_DOCS=1

inherit oasis

MY_P=${PN/-/_}-${PV}
DESCRIPTION="OCaml bindings for RE2"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}.00/individual/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-ml/type-conv-${PV}:=
	dev-ml/core:=
	dev-ml/bin-prot:=
	dev-ml/sexplib:=
	dev-ml/comparelib:=
	dev-libs/re2:="
RDEPEND="${DEPEND}"

DOCS=( "README.txt" )
S="${WORKDIR}/${MY_P}"
