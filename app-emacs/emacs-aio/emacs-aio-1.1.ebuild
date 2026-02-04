# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Async and await functions for Emacs Lisp"
HOMEPAGE="https://github.com/skeeto/emacs-aio/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/skeeto/${PN}"
else
	SRC_URI="https://github.com/skeeto/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Unlicense"
SLOT="0"

ELISP_REMOVE="
	aio-contrib.el
"

DOCS=( README.md )

elisp-enable-tests ert .
