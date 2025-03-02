# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${PN}-${PV/./-}
DESCRIPTION="The GNU Emacs Lisp Reference Manual"
HOMEPAGE="https://www.gnu.org/software/emacs/manual/"
SRC_URI="https://ftp.gnu.org/old-gnu/emacs/${MY_P}.tar.gz
	https://dev.gentoo.org/~ulm/emacs/${P}-patches.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Texinfo-manual"
SLOT="19"
KEYWORDS="amd64 ppc x86"

BDEPEND="sys-apps/texinfo"

PATCHES=("${WORKDIR}/patch")

src_prepare() {
	default
	# remove pre-made info files
	rm -f elisp elisp-[0-9]* || die
}

src_compile() {
	ln -s index.unperm index.texi || die
	makeinfo --no-split elisp.texi || die
}

src_install() {
	doinfo elisp${SLOT}.info
	dodoc README
}
