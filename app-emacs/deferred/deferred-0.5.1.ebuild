# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Deferred and Concurrent - simple asynchronous functions for Emacs Lisp"
HOMEPAGE="https://github.com/kiwanami/emacs-deferred/"
SRC_URI="https://github.com/kiwanami/emacs-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${P}

LICENSE="GPL-3+"
KEYWORDS="amd64 ~arm64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-emacs/ert-runner
		app-emacs/undercover
	)
"

DOCS=( README-concurrent.ja.markdown README-concurrent.markdown
	   README.ja.markdown README.markdown sample )

# "Concurrent" tests pass, "Deferred" tests are malformed
ELISP_REMOVE="test/${PN}-test.el"
SITEFILE="50${PN}-gentoo.el"

src_test() {
	ert-runner --reporter ert+duration || die
}
