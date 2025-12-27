# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="2b0672b04ef3e95c25f849dceb10d669296a188b"

inherit elisp readme.gentoo-r1

DESCRIPTION="Zenburn color theme for Emacs"
HOMEPAGE="https://web.archive.org/web/20140612104441/http://slinky.imukuppi.org/zenburnpage/
	https://github.com/dbrock/zenburn-el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/dbrock/${PN}-el"
else
	SRC_URI="https://github.com/dbrock/${PN}-el/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-el-${COMMIT}"

	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	app-emacs/color-theme
"
BDEPEND="
	${RDEPEND}
"

DOC_CONTENTS="To enable zenburn by default, initialise it in your ~/.emacs:
	\n\t(color-theme-zenburn)"
SITEFILE="50${PN}-gentoo.el"
