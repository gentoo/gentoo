# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Major mode for Clojure code"
HOMEPAGE="https://github.com/clojure-emacs/clojure-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/clojure-emacs/${PN}.git"
else
	SRC_URI="https://github.com/clojure-emacs/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

BDEPEND="
	test? (
		app-emacs/s
		app-emacs/paredit
	)
"

DOCS=( README.md doc )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup test
