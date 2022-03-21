# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=26

inherit elisp

DESCRIPTION="Consult integration for Flycheck"
HOMEPAGE="https://github.com/minad/consult-flycheck"
SRC_URI="https://github.com/minad/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

SITEFILE="50${PN}-gentoo.el"

DEPEND="app-emacs/consult
	app-emacs/flycheck"
RDEPEND="${DEPEND}"
