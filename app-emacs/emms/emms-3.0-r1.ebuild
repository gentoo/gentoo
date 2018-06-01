# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp toolchain-funcs

DESCRIPTION="The Emacs Multimedia System"
HOMEPAGE="https://www.gnu.org/software/emms/
	https://www.emacswiki.org/emacs/EMMS"
SRC_URI="https://www.gnu.org/software/emms/download/${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="media-libs/taglib"
RDEPEND="${DEPEND}"

# EMMS can use almost anything for playing media files therefore the dependency
# possibilities are so broad that we refrain from setting anything explicitly
# in DEPEND/RDEPEND.

ELISP_PATCHES="${P}-Makefile.patch
	${P}-texinfo-5.patch"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	emake CC="$(tc-getCC)" \
		EMACS=emacs \
		all emms-print-metadata
}

src_install() {
	elisp-install ${PN} *.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	doinfo *.info*
	dobin *-wrapper emms-print-metadata
	dodoc AUTHORS ChangeLog FAQ NEWS README RELEASE
}
