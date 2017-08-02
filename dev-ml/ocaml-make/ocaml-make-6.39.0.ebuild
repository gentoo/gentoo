# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Generic O'Caml Makefile for GNU Make"
HOMEPAGE="http://mmottl.github.io/ocaml-makefile/ https://github.com/mmottl/ocaml-makefile"
LICENSE="LGPL-2.1"

DEPEND=""
RDEPEND=">=dev-lang/ocaml-3.06-r1
	>=dev-ml/findlib-0.8"
SRC_URI="https://github.com/mmottl/ocaml-makefile/releases/download/${PV}/ocaml-makefile-${PV}.tbz"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="examples"
S="${WORKDIR}/${PN}file-${PV}"

src_install () {
	# Just put the OCamlMakefile into /usr/include
	# where GNU Make will automatically pick it up.
	insinto /usr/include
	doins OCamlMakefile
	# install documentation
	dodoc README.md CHANGES.md

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r calc camlp4 gtk idl threads
	fi
}
