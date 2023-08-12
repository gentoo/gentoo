# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Probably the sharpest git repo organizer & rebase/merge workflow automation tool"
HOMEPAGE="https://github.com/VirtusLab/git-machete https://pypi.org/project/git-machete/"
# No tests in PyPI tarballs
SRC_URI="https://github.com/VirtusLab/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="dev-vcs/git"
BDEPEND="test? (
	>=dev-python/pytest-mock-3.10.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-xdist-3.2.1[${PYTHON_USEDEP}]
)"

DOCS=( CONTRIBUTING.md README.md )

distutils_enable_sphinx docs/source dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

# Several of the fish- and zsh-completion tests appear to be broken
EPYTEST_DESELECT=(
	tests/completion_e2e/test_completion_e2e.py::TestCompletionEndToEnd::test_completion
)

src_install() {
	distutils-r1_src_install

	newbashcomp completion/${PN}.completion.bash ${PN}

	insinto /usr/share/fish/vendor_completions.d
	doins completion/${PN}.fish

	insinto /usr/share/zsh/site-functions
	newins completion/${PN}.completion.zsh _${PN}
}
