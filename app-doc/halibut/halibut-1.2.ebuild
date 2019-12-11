# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="yet another free document preparation system"
HOMEPAGE="https://www.chiark.greenend.org.uk/~sgtatham/halibut/"
SRC_URI="https://www.chiark.greenend.org.uk/~sgtatham/${PN}/${P}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_compile() {
	tc-export CC
	CFLAGS="${CFLAGS}" \
	CPPFLAGS="${CPPFLAGS}" \
	LFLAGS="${LDFLAGS}" \
	BUILDDIR="${S}/build" \
	VERSION="${PV}" \
	emake
	emake -C doc
}

DOCS=( doc/halibut.txt )
HTML_DOCS=(
	doc/index.html
	doc/IndexPage.html
	doc/input.html
	doc/intro.html
	doc/licence.html
	doc/manpage.html
	doc/output.html
	doc/running.html
)

src_install() {
	dobin build/halibut
	doman doc/halibut.1
	doinfo doc/halibut.info
	einstalldocs
}
