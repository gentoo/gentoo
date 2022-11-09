# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24

inherit elisp

DESCRIPTION="A great IRC client for Emacs"
HOMEPAGE="https://github.com/jorgenschaefer/circe
	https://www.emacswiki.org/emacs/Circe"
SRC_URI="https://github.com/jorgenschaefer/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( app-emacs/buttercup )"

DOCS=( AUTHORS.md CONTRIBUTING.md NEWS.md README.md images )
ELISP_REMOVE="${PN}-pkg.el"
SITEFILE="50${PN}-gentoo.el"

src_test() {
	buttercup -L . --traceback full tests || die
}
