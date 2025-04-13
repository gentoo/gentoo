# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="27.1"

inherit elisp

DESCRIPTION="Fast, configurable indentation guide-bars for Emacs"
HOMEPAGE="https://github.com/jdtsmith/indent-bars/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/jdtsmith/${PN}.git"
else
	SRC_URI="https://github.com/jdtsmith/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-30.0.0.0
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.md examples.md )
SITEFILE="50${PN}-gentoo.el"
