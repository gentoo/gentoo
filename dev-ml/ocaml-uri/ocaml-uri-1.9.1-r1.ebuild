# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="RFC3986 URI parsing library for OCaml"
HOMEPAGE="https://github.com/mirage/ocaml-uri https://mirage.io"
SRC_URI="https://github.com/mirage/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="allservices"

RDEPEND="
	dev-ml/ocaml-re:=
	>=dev-ml/sexplib-109.53.00:=
	<dev-ml/sexplib-113.01.00
	dev-ml/stringext:=
	dev-ml/type-conv:=
"
DEPEND="
	test? ( >=dev-ml/ounit-1.0.2 )
	${RDEPEND}
"

src_configure() {
	oasis_configure_opts="
		$(use_enable allservices)
	" oasis_src_configure
}

DOCS=( CHANGES README.md )
