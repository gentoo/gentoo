# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs eutils

DESCRIPTION="A rewrite of CVSup"
HOMEPAGE="http://www.mu.org/~mux/csup.html"
SRC_URI="http://mu.org/~mux/csup-snap-${PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="
	sys-libs/zlib:0=
	dev-libs/openssl:0="

RDEPEND="
	${DEPEND}
	!>=sys-freebsd/freebsd-ubin-6.2_beta1"

DEPEND="
	${DEPEND}
	>=sys-devel/bison-2.1"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}/${P}-respectflags.patch")

src_compile() {
	# unable to work with yacc, but bison is ok.
	emake \
		CC="$(tc-getCC)" \
		PREFIX=/usr \
		YACC=bison
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}
