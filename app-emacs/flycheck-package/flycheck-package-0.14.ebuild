# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.1

inherit elisp

DESCRIPTION="Flycheck checker for Emacs Lisp package metadata"
HOMEPAGE="https://github.com/purcell/flycheck-package/"
SRC_URI="https://github.com/purcell/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="
	app-emacs/flycheck
	app-emacs/package-lint
"
BDEPEND="${RDEPEND}"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
