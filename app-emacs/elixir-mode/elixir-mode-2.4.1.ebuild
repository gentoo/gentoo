# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs major mode for editing Elixir files"
HOMEPAGE="https://github.com/elixir-editors/emacs-elixir/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/elixir-editors/emacs-elixir.git"
else
	SRC_URI="https://github.com/elixir-editors/emacs-elixir/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/emacs-elixir-${PV}
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-lang/elixir )
"

DOCS=( CHANGELOG.md README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner

src_test() {
	ert-runner -L . -L tests --reporter ert+duration tests || die
}
