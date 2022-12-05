# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.3

inherit elisp

DESCRIPTION="GNU Emacs major mode for editing BNF grammars"
HOMEPAGE="https://github.com/sergeyklay/bnf-mode/"
SRC_URI="https://github.com/sergeyklay/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-emacs/buttercup
		app-emacs/undercover
	)
"

DOCS=( NEWS README.org )
ELISP_TEXINFO="bnf-mode.texi"
SITEFILE="50${PN}-gentoo.el"

src_test() {
	buttercup -L . -L test --traceback full || die
}
