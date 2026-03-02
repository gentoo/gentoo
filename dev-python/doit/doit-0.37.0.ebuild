# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi shell-completion

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
"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/pyflakes[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/furo

src_prepare() {
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
	newzshcomp zsh_completion_doit _${PN}
}
