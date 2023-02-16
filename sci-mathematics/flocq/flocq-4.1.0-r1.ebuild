# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing

DESCRIPTION="Formalization of floating-point arithmetic for the Coq proof assistant"
HOMEPAGE="http://flocq.gforge.inria.fr/
	https://gitlab.inria.fr/flocq/flocq/"
SRC_URI="https://flocq.gitlabpages.inria.fr/releases/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/ocaml:=
	>=sci-mathematics/coq-8.12:=
"
DEPEND="${RDEPEND}"

src_compile() {
	./remake --jobs=$(makeopts_jobs) || die
}

src_install() {
	DESTDIR="${D}" ./remake install || die

	dodoc AUTHORS INSTALL.md NEWS.md README.md

	insinto /usr/share/${PN}
	doins -r examples
}
