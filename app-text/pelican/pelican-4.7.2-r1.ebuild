# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A tool to generate a static blog, with restructured text or markdown input files"
HOMEPAGE="https://blog.getpelican.com/ https://pypi.org/project/pelican/"
SRC_URI="https://github.com/getpelican/pelican/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="doc examples markdown"

RESTRICT="test"
RDEPEND=">=dev-python/docutils-0.16[${PYTHON_USEDEP}]
	>=dev-python/blinker-1.4[${PYTHON_USEDEP}]
	>=dev-python/feedgenerator-1.9[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.6[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8[${PYTHON_USEDEP}]
	>=dev-python/pytz-2020.1[${PYTHON_USEDEP}]
	>=dev-python/rich-10.1[${PYTHON_USEDEP}]
	>=dev-python/unidecode-1.1[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	markdown? ( >=dev-python/markdown-3.1[${PYTHON_USEDEP}] )"
BDEPEND="test? ( >=dev-python/markdown-3.1[${PYTHON_USEDEP}] )"

DOCS=( README.rst )

distutils_enable_tests nose

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	if use examples; then
		insinto "/usr/share/doc/${PF}"
		docompress -x "/usr/share/doc/${PF}/samples"
		doins -r samples
	fi
	distutils-r1_python_install_all
}
