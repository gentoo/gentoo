# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="OCaml interface to the libcurl library"
HOMEPAGE="http://forge.ocamlcore.org/projects/ocurl/ https://github.com/ygrek/ocurl"
SRC_URI="https://github.com/ygrek/ocurl/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 x86"
IUSE="examples +ocamlopt"

RDEPEND=">=net-misc/curl-7.9.8
	dev-ml/lwt:=
	dev-ml/camlp4:=
	>=dev-lang/ocaml-3.12:=[ocamlopt?]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	emake -j1 all
}

src_install() {
	findlib_src_install

	dodoc CHANGES.txt README.md

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
