# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_P="mmixware-release-${PV}"
DESCRIPTION="Donald Knuth's MMIX Assembler and Simulator"
HOMEPAGE="
	https://www-cs-faculty.stanford.edu/~knuth/mmix.html
	https://mmix.cs.hm.edu/
	https://gitlab.lrz.de/mmix/mmixware
"
SRC_URI="https://gitlab.lrz.de/mmix/mmixware/-/archive/release-${PV}/${MY_P}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="mmix"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

BDEPEND="
	virtual/tex-base
	doc? ( dev-texlive/texlive-plaingeneric )
"
# media-sound/mmix and dev-lang/mmix both install 'mmix' binary, bug #426874
RDEPEND="!media-sound/mmix"

PATCHES=(
	"${FILESDIR}"/${PN}-20261012-makefile.patch
)

src_compile() {
	# K&R function definitions, not C23 compatible
	append-cflags -std=gnu17

	export VARTEXFONTS="${T}"/fonts
	emake all CC="$(tc-getCC)" CFLAGS="${CFLAGS}"

	use doc && emake doc
}

src_install() {
	dobin mmix mmixal mmmix mmotype abstime
	doman mmix.1
	dodoc README BUGS.TXT CHANGES.TXT
	use doc && dodoc *.ps
}
