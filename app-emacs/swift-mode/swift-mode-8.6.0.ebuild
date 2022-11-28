# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Emacs support for Apple's Swift programming language"
HOMEPAGE="https://github.com/swift-emacs/swift-mode/"
SRC_URI="https://github.com/swift-emacs/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md CONTRIBUTING.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS}                      \
		-L . -L test                            \
		-l test/swift-mode-test.el              \
		-f swift-mode:run-test || die "tests failed"
}
