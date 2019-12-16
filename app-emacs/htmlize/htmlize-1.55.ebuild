# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

MY_PN="emacs-${PN}"
DESCRIPTION="HTML-ize font-lock buffers in Emacs"
HOMEPAGE="https://www.emacswiki.org/emacs/Htmlize
	https://github.com/hniksic/emacs-htmlize"
SRC_URI="https://github.com/hniksic/${MY_PN}/archive/release/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

S="${WORKDIR}/${MY_PN}-release-${PV}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md NEWS"
