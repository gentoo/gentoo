# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Emacs support for Apple's Swift programming language"
HOMEPAGE="https://github.com/swift-emacs/swift-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/swift-emacs/${PN}"
else
	SRC_URI="https://github.com/swift-emacs/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md CONTRIBUTING.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	${EMACS} ${EMACSFLAGS}                      \
		-L . -L test                            \
		-l test/swift-mode-test.el              \
		-f swift-mode:run-test || die "tests failed"
}
