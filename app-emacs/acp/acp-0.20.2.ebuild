# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="28.1"

inherit elisp

DESCRIPTION="Agent Client Protocol implementation for GNU Emacs"
HOMEPAGE="https://github.com/xenodium/acp.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xenodium/${PN}.el"
else
	SRC_URI="https://github.com/xenodium/${PN}.el/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}.el-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert ./tests/
