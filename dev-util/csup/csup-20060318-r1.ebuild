# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A rewrite of CVSup"
HOMEPAGE="http://www.mu.org/~mux/csup.html"
SRC_URI="http://mu.org/~mux/csup-snap-${PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	sys-libs/zlib:0=
	dev-libs/openssl:0="
DEPEND="${RDEPEND}"
BDEPEND=">=sys-devel/bison-2.1"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}"/${P}-respectflags.patch )

src_compile() {
	# unable to work with yacc, but bison is ok.
	emake \
		CC="$(tc-getCC)" \
		PREFIX="${EPREFIX}"/usr \
		YACC=bison
}

src_install() {
	dobin csup
	doman csup.1
	einstalldocs
}
