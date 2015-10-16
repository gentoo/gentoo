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
SLOT="0"
KEYWORDS="~amd64"
IUSE="async lwt nettests"

RDEPEND="
	async? ( dev-ml/async:= )
	!<dev-ml/async-112.24.00
	>=dev-ml/ocaml-base64-2.0.0:=
	dev-ml/cmdliner:=
	dev-ml/mirage-profile:=
	!<dev-ml/mirage-types-1.2.0
	>=dev-ml/ocaml-cstruct-1.0.1:=
	>=dev-ml/ocaml-ipaddr-2.6.0:=
	dev-ml/ocaml-re:=
	>=dev-ml/ocaml-uri-1.7.0:=
	!dev-ml/odns
	lwt? ( >=dev-ml/lwt-2.4.7:=
		dev-ml/ocaml-cstruct:=[lwt(-)] )
"
DEPEND="
	>=dev-lang/ocaml-4
	test? ( dev-ml/ounit
		dev-ml/ocaml-pcap )
	${RDEPEND}
"

oasis_configure_opts="
	$(oasis_use_enable async async)
	$(oasis_use_enable lwt lwt)
	$(oasis_use_enable nettests nettests)
"

DOCS=( CHANGES README.md TODO.md )
