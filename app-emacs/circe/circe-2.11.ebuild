# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=24

inherit elisp

DESCRIPTION="A great IRC client for Emacs"
HOMEPAGE="https://github.com/jorgenschaefer/circe
	https://www.emacswiki.org/emacs/Circe"
SRC_URI="https://github.com/jorgenschaefer/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

ELISP_REMOVE="circe-pkg.el"
SITEFILE="50${PN}-gentoo.el"
DOCS="AUTHORS.md CONTRIBUTING.md NEWS.md README.md"
