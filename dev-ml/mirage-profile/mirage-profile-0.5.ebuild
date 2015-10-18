# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Collect profiling information"
HOMEPAGE="https://github.com/mirage/mirage-profile https://mirage.io"
SRC_URI="https://github.com/mirage/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""
# https://github.com/mirage/mirage-profile/issues/11
RESTRICT="test"

RDEPEND="
	>=dev-lang/ocaml-4:=
	dev-ml/io-page:=
	dev-ml/lwt:=
	dev-ml/ocaml-cstruct:=[camlp4(-)]
	dev-ml/ocplib-endian:=
"
DEPEND="
	${RDEPEND}
"

DOCS=( README.md )
