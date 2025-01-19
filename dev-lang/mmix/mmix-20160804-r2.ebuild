# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Donald Knuth's MMIX Assembler and Simulator"
HOMEPAGE="https://www-cs-faculty.stanford.edu/~knuth/mmix.html http://mmix.cs.hm.edu"
SRC_URI="http://mmix.cs.hm.edu/src/${P}.tgz"
S="${WORKDIR}"

DEPEND="virtual/tex-base
	doc? ( dev-texlive/texlive-plaingeneric )"
# media-sound/mmix and dev-lang/mmix both install 'mmix' binary, bug #426874
RDEPEND="!!media-sound/mmix"

LICENSE="mmix"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

PATCHES=(
	"${FILESDIR}"/${PN}-20110420-makefile.patch
	"${FILESDIR}"/${PN}-20131017-format-security.patch
	"${FILESDIR}"/${PN}-20160804-gcc-10.patch
	"${FILESDIR}"/${PN}-20160804-implicit-int.patch
)

src_compile() {
	append-flags -std=gnu17
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
