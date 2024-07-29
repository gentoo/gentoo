# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER=doxygen
DOCS_DIR=doc/doxygen

inherit docs multiprocessing

DESCRIPTION="Tool for verifying floating-point or fixed-point arithmetic"
HOMEPAGE="https://gappa.gitlabpages.inria.fr/
	https://gitlab.inria.fr/gappa/gappa/"
SRC_URI="https://gappa.gitlabpages.inria.fr/releases/${P}.tar.gz"

LICENSE="CeCILL-2 GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/boost:=
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS INSTALL.md NEWS.md README.md )

src_compile() {
	./remake --jobs=$(makeopts_jobs) || die

	docs_compile
}

src_test() {
	./remake --jobs=$(makeopts_jobs) check || die
}

src_install() {
	DESTDIR="${D}" ./remake install || die

	einstalldocs
}
