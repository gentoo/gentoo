# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

COMMIT="2b0672b04ef3e95c25f849dceb10d669296a188b"
DESCRIPTION="Zenburn color theme for Emacs"
HOMEPAGE="https://web.archive.org/web/20140612104441/http://slinky.imukuppi.org/zenburnpage/
	https://github.com/dbrock/zenburn-el"
SRC_URI="https://github.com/dbrock/${PN}-el/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="app-emacs/color-theme"
BDEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-el-${COMMIT}"
SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="To enable zenburn by default, initialise it in your ~/.emacs:
	\n\t(color-theme-zenburn)"
