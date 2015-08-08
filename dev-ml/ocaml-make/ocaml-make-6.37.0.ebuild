# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Generic O'Caml Makefile for GNU Make"
HOMEPAGE="http://bitbucket.org/mmottl/ocaml-makefile"
LICENSE="LGPL-2.1"

DEPEND=""
RDEPEND=">=dev-lang/ocaml-3.06-r1
	>=dev-ml/findlib-0.8"
SRC_URI="http://bitbucket.org/mmottl/ocaml-makefile/downloads/${PN}file-${PV}.tar.gz"
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
	dodoc README.md CHANGES.txt

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r calc camlp4 gtk idl threads
	fi
}
