# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="An authoring and publishing environment for Emacs"
HOMEPAGE="https://www.gnu.org/software/emacs-muse/"
SRC_URI="https://github.com/alexott/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.2+ GPL-2 MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
#IUSE="test"
RESTRICT="test"					#426546

#DEPEND="test? ( app-emacs/htmlize )"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	emake -j1
}

src_install() {
	elisp-install ${PN} lisp/*.el lisp/*.elc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	doinfo texi/muse.info
	dodoc AUTHORS NEWS README ChangeLog*
	dodoc -r contrib etc examples experimental scripts
}
