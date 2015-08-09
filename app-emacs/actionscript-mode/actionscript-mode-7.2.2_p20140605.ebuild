# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

GITHUB_USER="austinhaas"
GITHUB_PROJECT="${PN}"
GITHUB_TAG="6822d0bfd5d7ff2c0b246ca90ef9480d3c528b97"

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
