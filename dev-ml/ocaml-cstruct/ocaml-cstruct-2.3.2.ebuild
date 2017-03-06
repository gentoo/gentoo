# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="Map OCaml arrays onto C-like structs"
HOMEPAGE="https://github.com/mirage/ocaml-cstruct https://mirage.io"
SRC_URI="https://github.com/mirage/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="async +lwt +ppx"

RDEPEND="
	async? ( dev-ml/async:= )
	lwt? ( dev-ml/lwt:= )
	ppx? ( dev-ml/ppx_tools:= )
	>=dev-lang/ocaml-4.01:=
	dev-ml/ocplib-endian:=
	dev-ml/sexplib:=
	dev-ml/type-conv:=
"
DEPEND="
	test? ( dev-ml/ounit )
	${RDEPEND}
"

src_configure() {
	oasis_configure_opts="
		$(use_enable lwt)
		$(use_enable async)
		$(use_enable ppx)
		--enable-unix
	" oasis_src_configure
}

DOCS=( CHANGES README.md TODO.md )
