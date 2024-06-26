# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit bash-completion-r1 distutils-r1 pypi

DESCRIPTION="Automation tool"
HOMEPAGE="
	https://pydoit.org/
	https://github.com/pydoit/doit/
	https://pypi.org/project/doit/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/pyinotify[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		|| (
			dev-python/tomli[${PYTHON_USEDEP}]
			dev-python/tomlkit[${PYTHON_USEDEP}]
		)
	' 3.10)
"
PDEPEND="
	>=dev-python/doit-py-0.4.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${PDEPEND}
		$(python_gen_impl_dep sqlite)
		dev-python/pyflakes[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx doc \
	dev-python/sphinx-rtd-theme

EPYTEST_DESELECT=(
	# test failing due to impact on PATH run in a sandbox
	tests/test_cmd_strace.py::TestCmdStrace::test_dep # #836164
	tests/test_cmd_strace.py::TestCmdStrace::test_target
)

src_prepare() {
	# Replace custom theme with builtin for documentation
	sed -e '/html_theme/s/press/sphinx_rtd_theme/' -i doc/conf.py || die
	# Remove non-exist modules for doc generation (#832754)
	sed \
		-e '/sphinx_sitemap/d' \
		-e '/sphinx_reredirects/d' \
		-i doc/conf.py || die

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	newbashcomp bash_completion_doit ${PN}
	insinto /usr/share/zsh/site-functions
	newins zsh_completion_doit _${PN}
}
