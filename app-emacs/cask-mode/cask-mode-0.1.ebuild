# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Major mode for editing Cask files for Emacs"
HOMEPAGE="https://github.com/Wilfred/cask-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/Wilfred/${PN}.git"
else
	SRC_URI="https://github.com/Wilfred/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

BDEPEND="
	test? (
		app-emacs/assess
	)
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test

src_prepare() {
	elisp_src_prepare

	# Silence a broken test
	sed -i "test/${PN}-test.el" \
		-e "s|ert-deftest cask-mode-highlight-comment|lambda|" \
		|| die
}
