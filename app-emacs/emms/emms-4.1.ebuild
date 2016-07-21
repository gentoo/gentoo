# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit elisp toolchain-funcs

DESCRIPTION="The Emacs Multimedia System"
HOMEPAGE="https://www.gnu.org/software/emms/
	https://www.emacswiki.org/emacs/EMMS"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="media-libs/taglib"
RDEPEND="${DEPEND}"

# EMMS can use almost anything for playing media files therefore the dependency
# possibilities are so broad that we refrain from setting anything explicitly
# in DEPEND/RDEPEND.

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	emake CC="$(tc-getCC)" \
		all emms-print-metadata
}

src_install() {
	elisp-install ${PN} lisp/*.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	doinfo doc/emms.info*
	dobin src/emms-print-metadata
	doman emms-print-metadata.1
	dodoc AUTHORS ChangeLog NEWS README THANKGNU
}
