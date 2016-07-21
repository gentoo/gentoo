# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="A modern list library for Emacs"
HOMEPAGE="https://github.com/magnars/dash.el"
SRC_URI="https://github.com/magnars/dash.el/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

SITEFILE="50${PN}-gentoo.el"

S="${WORKDIR}/${PN}.el-${PV}"

src_test() {
	./run-tests.sh || die
}

src_install() {
	elisp-install ${PN} *.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	doinfo dash.info
	dodoc README.md
}
