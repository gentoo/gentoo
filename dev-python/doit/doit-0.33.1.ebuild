# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Automation tool"
HOMEPAGE="https://pydoit.org/ https://pypi.org/project/doit/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/pyinotify[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
		>=dev-python/pytest-5.4[${PYTHON_USEDEP}]
	)"
PDEPEND=">=dev-python/doit-py-0.4.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/sphinx_rtd_theme

src_prepare() {
	default
	# Replace custom theme with builtin for documentation
	sed -i -e "s:'press':'sphinx_rtd_theme':" doc/conf.py || die
	# Disable test failing due to impact on PATH run in a sandbox
	sed -i -e "s:test_target:_&:" tests/test_cmd_strace.py || die
}

src_install() {
	distutils-r1_src_install
	newbashcomp bash_completion_doit ${PN}
	insinto /usr/share/zsh/site-functions
	newins zsh_completion_doit _${PN}
}
