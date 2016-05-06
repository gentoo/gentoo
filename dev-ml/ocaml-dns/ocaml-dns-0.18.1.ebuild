# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="A pure OCaml implementation of the DNS protocol"
HOMEPAGE="https://github.com/mirage/ocaml-dns https://mirage.io"
SRC_URI="https://github.com/mirage/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2 LGPL-2.1-with-linking-exception ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="async +lwt"

RDEPEND="
	async? ( >=dev-ml/async-112.24.00:= )
	lwt? ( >=dev-ml/lwt-2.4.7:=
		dev-ml/ocaml-cstruct:=[lwt(-)] )
	>=dev-lang/ocaml-4:=
	dev-ml/cmdliner:=
	dev-ml/mirage-profile:=
	>=dev-ml/ocaml-base64-2.0.0:=
	>=dev-ml/ocaml-cstruct-1.9.0:=
	>=dev-ml/ocaml-ipaddr-2.6.0:=
	dev-ml/ocaml-re:=
	>=dev-ml/ocaml-uri-1.7.0:=
	dev-ml/ocaml-hashcons:=[ocamlopt?]
	!<dev-ml/mirage-types-1.2.0
	!dev-ml/odns
"
DEPEND="
	test? ( dev-ml/ounit
		dev-ml/ocaml-pcap )
	${RDEPEND}
"

src_configure() {
	oasis_configure_opts="
		$(use_enable async)
		$(use_enable lwt)
		$(use_enable test nettests)
	" oasis_src_configure
}

DOCS=( CHANGES README.md TODO.md )
