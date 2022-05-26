# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Company documentation popups for completion candidates"
HOMEPAGE="https://github.com/company-mode/company-quickhelp/"
SRC_URI="https://github.com/company-mode/${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-emacs/company-mode
	app-emacs/pos-tip
"
BDEPEND="${RDEPEND}"

DOCS=( CHANGELOG.md README.md company-quickhelp.png )
SITEFILE="50${PN}-gentoo.el"
