# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Donald Knuth's MMIX Assembler and Simulator"
HOMEPAGE="https://www-cs-faculty.stanford.edu/~knuth/mmix.html http://mmix.cs.hm.edu"
SRC_URI="http://mmix.cs.hm.edu/src/${P}.tgz"

DEPEND="virtual/tex-base
	doc? ( dev-texlive/texlive-plaingeneric )"
# media-sound/mmix and dev-lang/mmix both install 'mmix' binary, bug #426874
RDEPEND="!!media-sound/mmix"

SLOT="0"
LICENSE="${PN}"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${PN}-20110420-makefile.patch
	"${FILESDIR}"/${PN}-20131017-format-security.patch
)

src_compile() {
	export VARTEXFONTS=${T}/fonts
	emake all \
		CFLAGS="${CFLAGS}" \
		CC="$(tc-getCC)"

	if use doc ; then
		emake doc
	fi
}

src_install() {
	dobin ${PN} ${PN}al m${PN} mmotype abstime
	dodoc README ${PN}.1

	use doc && dodoc *.ps
}
