# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Major mode for Clojure code"
HOMEPAGE="https://github.com/clojure-emacs/clojure-mode/"
SRC_URI="https://github.com/clojure-emacs/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="test"         # w/o lexical-binding needed by buttercup >=1.34, should be fixed in git.

BDEPEND="
	test? (
		app-emacs/s
		app-emacs/paredit
	)
"

DOCS=( README.md doc )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup test
