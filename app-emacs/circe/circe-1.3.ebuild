# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="A great IRC client for Emacs"
HOMEPAGE="https://github.com/jorgenschaefer/circe
	https://www.emacswiki.org/emacs/Circe"
SRC_URI="https://github.com/jorgenschaefer/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

S="${WORKDIR}/${PN}-${P}/lisp"
SITEFILE="50${PN}-gentoo.el"
DOCS="../README.md"
