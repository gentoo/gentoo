# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing

DESCRIPTION="Allows the certificates Gappa generates to be imported by the Coq"
HOMEPAGE="https://gappa.gitlabpages.inria.fr/
	https://gitlab.inria.fr/gappa/coq/"
SRC_URI="https://gappa.gitlabpages.inria.fr/releases/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ocamlopt"

RDEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	>=sci-mathematics/coq-8.12:=
	sci-mathematics/flocq:=
	sci-mathematics/gappa
"
DEPEND="${RDEPEND}"
BDEPEND="dev-ml/findlib"

# Do not complain about CFLAGS etc since ML projects do not use them.
QA_FLAGS_IGNORED='.*'

src_compile() {
	./remake --jobs=$(makeopts_jobs) || die
}

src_test() {
	./remake --jobs=$(makeopts_jobs) check || die
}

src_install() {
	DESTDIR="${D}" ./remake install || die

	dodoc AUTHORS INSTALL.md NEWS.md README.md
}
