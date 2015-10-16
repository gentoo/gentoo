# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Map OCaml arrays onto C-like structs"
HOMEPAGE="https://github.com/mirage/ocaml-cstruct https://mirage.io"
SRC_URI="https://github.com/mirage/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="async camlp4 lwt"

RDEPEND="
	async? ( dev-ml/async:= )
	camlp4? ( dev-ml/camlp4:= )
	lwt? ( dev-ml/lwt:= )
	dev-ml/ocplib-endian:=
	dev-ml/sexplib:=
"
DEPEND="
	>=dev-lang/ocaml-4.01
	dev-ml/type-conv
	test? ( dev-ml/ounit )
	${RDEPEND}
"

oasis_configure_opts="
	$(oasis_use_enable lwt lwt)
	$(oasis_use_enable camlp4 camlp4)
	$(oasis_use_enable async async)
	--enable-unix
"
DOCS=( CHANGES README.md TODO.md )
