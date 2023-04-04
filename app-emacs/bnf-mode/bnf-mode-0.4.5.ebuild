# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="GNU Emacs major mode for editing BNF grammars"
HOMEPAGE="https://github.com/sergeyklay/bnf-mode/"
SRC_URI="https://github.com/sergeyklay/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="test? ( app-emacs/undercover )"

DOCS=( NEWS README.org )
ELISP_TEXINFO="bnf-mode.texi"
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup test
