# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools toolchain-funcs

DESCRIPTION="escm - Embedded Scheme Processor"
HOMEPAGE="https://practical-scheme.net/vault/escm.html"
SRC_URI="https://practical-scheme.net/vault/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ia64 x86"
IUSE=""

RDEPEND="|| (
		dev-scheme/gauche
		dev-scheme/guile
	)"
S="${WORKDIR}/${PN}"

HTML_DOCS=( ${PN}.html )

src_prepare() {
	sed -i "6s/scm, snow/scm gosh, gosh/" configure.in

	default
	mv configure.{in,ac} || die
	eautoconf
	tc-export CC
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	einstalldocs
}
