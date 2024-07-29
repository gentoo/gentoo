# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Inline (Unit) Tests for OCaml"
HOMEPAGE="https://github.com/vincent-hugot/qtest"
SRC_URI="https://github.com/vincent-hugot/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/ounit2:=
	dev-ml/qcheck:=
"
DEPEND="${RDEPEND}"
