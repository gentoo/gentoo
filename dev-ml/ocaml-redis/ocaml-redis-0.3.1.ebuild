# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
OASIS_BUILD_TESTS=1
OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Redis bindings for OCaml"
HOMEPAGE="http://0xffea.github.io/ocaml-redis/"
SRC_URI="https://github.com/0xffea/ocaml-redis/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+lwt"

RDEPEND="
	dev-ml/ocaml-re:=
	dev-ml/uuidm:=
	lwt? ( dev-ml/lwt:= )
"
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit )"

src_configure() {
	oasis_configure_opts="$(use_enable lwt)" oasis_src_configure
}
