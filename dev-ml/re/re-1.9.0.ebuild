# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Regular expression library for OCaml"
HOMEPAGE="https://github.com/ocaml/ocaml-re"
SRC_URI="https://github.com/ocaml/ocaml-re/archive/${PV}.tar.gz -> ocaml-${P}.tar.gz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+ocamlopt test"

RDEPEND="!dev-ml/ocaml-re
	dev-ml/seq:=
"
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit )"
S="${WORKDIR}/ocaml-${P}"
PATCHES=( "${FILESDIR}/ounit2.patch" )
