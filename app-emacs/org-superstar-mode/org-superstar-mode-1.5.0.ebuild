# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Prettify headings and plain lists in Org mode (use UTF8 bullets)"
HOMEPAGE="https://github.com/integral-dw/org-superstar-mode/"
SRC_URI="https://github.com/integral-dw/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( DEMO.org README.org demos )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	emake EMACS="${EMACS}" EFLAGS="${EMACSFLAGS}" -C tests
}
