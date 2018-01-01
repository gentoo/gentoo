# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Donald Knuth's MMIX Assembler and Simulator"
HOMEPAGE="http://www-cs-faculty.stanford.edu/~knuth/mmix.html http://mmix.cs.hm.edu"
SRC_URI="http://mmix.cs.hm.edu/src/${P}.tgz"

DEPEND="virtual/tex-base
	doc? ( || ( dev-texlive/texlive-plaingeneric dev-texlive/texlive-genericrecommended ) )"
RDEPEND=""

SLOT="0"
LICENSE="${PN}"
KEYWORDS="amd64 x86"
IUSE="doc"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${PN}-20110420-makefile.patch
	"${FILESDIR}"/${PN}-20131017-format-security.patch
)

src_compile() {
	emake all \
		CFLAGS="${CFLAGS}" \
		CC="$(tc-getCC)"

	if use doc ; then
		emake doc
	fi
}

src_install () {
	dobin ${PN} ${PN}al m${PN} mmotype abstime
	dodoc README ${PN}.1

	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins *.ps
	fi
}
