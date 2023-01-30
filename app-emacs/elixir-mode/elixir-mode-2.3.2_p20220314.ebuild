# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=e0d0466d83ec80ddb412bb1473908a21baad1ec3
NEED_EMACS=25

inherit elisp

DESCRIPTION="Emacs major mode for editing Elixir files"
HOMEPAGE="https://github.com/elixir-editors/emacs-elixir/"
SRC_URI="https://github.com/elixir-editors/emacs-elixir/archive/${COMMIT}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/emacs-elixir-${COMMIT}

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-emacs/ert-runner
		dev-lang/elixir
	)
"

DOCS=( CHANGELOG.md README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	ert-runner -L . -L tests --reporter ert+duration tests || die
}
