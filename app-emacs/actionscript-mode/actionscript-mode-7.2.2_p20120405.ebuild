# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/actionscript-mode/actionscript-mode-7.2.2_p20120405.ebuild,v 1.2 2014/11/15 10:15:39 ulm Exp $

EAPI=4

inherit elisp

GITHUB_USER="austinhaas"
GITHUB_PROJECT="${PN}"
GITHUB_TAG="aa7e63d566a815152e7e652010becd46a406abb2"

DESCRIPTION="A major mode for GNU Emacs for editing Actionscript 3 files"
HOMEPAGE="https://github.com/austinhaas/actionscript-mode"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}/tarball/${GITHUB_TAG} -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS="README.txt"
SITEFILE="50${PN}-gentoo.el"

src_unpack() {
	unpack ${A}
	mv "${GITHUB_USER}-${GITHUB_PROJECT}"-* ${P} || die
}
