# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

DESCRIPTION="Generates patchset information from a CVS repository (supports fast-import)"
HOMEPAGE="http://www.catb.org/~esr/cvsps/"
SRC_URI="http://www.catb.org/~esr/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	app-text/asciidoc"

RESTRICT=test # upstream does not ship tests

PATCHES=("${FILESDIR}"/${P}-make.patch)

src_prepare() {
	default

	local gentoo_name=${PN}-3

	mv ${PN}.asc ${gentoo_name}.asc || die
	sed -i "s/${PN}/${gentoo_name}/g" ${gentoo_name}.asc || die
	sed -i "s/PROG         = cvsps/PROG         = ${gentoo_name}/" Makefile || die

	tc-export CC
	export prefix="${EPREFIX}"/usr
}

src_install() {
	default

	dodoc README
}
