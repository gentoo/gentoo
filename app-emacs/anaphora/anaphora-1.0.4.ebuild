# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Anaphoric expressions for Emacs Lisp, providing implicit temporary variables"
HOMEPAGE="https://github.com/rolandwalker/anaphora/"
SRC_URI="https://github.com/rolandwalker/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DOCS=( README.markdown )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	emake test-batch
}
