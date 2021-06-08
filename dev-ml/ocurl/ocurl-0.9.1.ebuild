# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="OCaml interface to the libcurl library"
HOMEPAGE="http://forge.ocamlcore.org/projects/ocurl/ https://github.com/ygrek/ocurl"
LICENSE="MIT"
SRC_URI="https://github.com/ygrek/ocurl/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/${PV}"
IUSE="examples +ocamlopt"

BDEPEND="virtual/pkgconfig"
RDEPEND=">=net-misc/curl-7.9.8
	dev-ml/lwt:=
	dev-ml/camlp4:=
	>=dev-lang/ocaml-3.12:=[ocamlopt?]"
DEPEND="${RDEPEND}"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"

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
