# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Minor mode for God-like command entering in GNU Emacs"
HOMEPAGE="https://github.com/emacsorphanage/god-mode/"
SRC_URI="https://github.com/emacsorphanage/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-emacs/ansi
		app-emacs/ecukes
		app-emacs/ecukes
		app-emacs/f
	)
"

DOCS=( .github/CONTRIBUTING.md .github/README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	ecukes --debug --reporter spec --verbose || die "tests failed"
}
