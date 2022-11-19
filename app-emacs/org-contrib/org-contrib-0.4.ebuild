# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=24

inherit elisp

DESCRIPTION="Contributed packages to Org"
HOMEPAGE="https://www.orgmode.org/"
SRC_URI="https://git.sr.ht/~bzg/${PN}/archive/release_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-release_${PV}/lisp"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=app-emacs/org-mode-9.5"

DOCS="../README.org"
SITEFILE="50${PN}-gentoo.el"
