# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="periodic table of the elements"
HOMEPAGE="http://elem.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/elem/${PN}-src-${PV}-Linux.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="x11-libs/xforms"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fix-build-system.patch
	"${FILESDIR}"/${P}-missing-stdlib.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_configure() {
	tc-export CC
}

src_compile() {
	emake all
}

src_install() {
	dobin elem elem-de elem-en

	rm -rf doc/CVS || die
	HTML_DOCS=( doc/. )
	einstalldocs
}
