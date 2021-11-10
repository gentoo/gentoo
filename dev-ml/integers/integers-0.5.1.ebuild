# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Various signed and unsigned integer types for OCaml"
HOMEPAGE="https://github.com/ocamllabs/ocaml-integers"
SRC_URI="https://github.com/ocamllabs/ocaml-integers/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ocaml-${P}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+ocamlopt"
