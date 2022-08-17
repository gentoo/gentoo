# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=b3aa4c53fc9e98648b25ad036e657632ae2fe192
NEED_EMACS=25

inherit elisp

DESCRIPTION="Support for the F# programming language"
HOMEPAGE="https://github.com/fsharp/emacs-fsharp-mode/"
SRC_URI="https://github.com/fsharp/emacs-${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${PN}-${H}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-emacs/s"
BDEPEND="
	${RDEPEND}
	test? ( app-emacs/buttercup )
"

DOCS=( CHANGELOG.md README.org )
ELISP_REMOVE="eglot-fsharp.el test/integration-tests.el"
SITEFILE="50${PN}-gentoo.el"

src_test() {
	buttercup -L . -L test --traceback full || die
}
