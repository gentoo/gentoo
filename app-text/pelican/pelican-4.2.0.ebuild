# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_5,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="A tool to generate a static blog, with restructured text or markdown input files"
HOMEPAGE="https://blog.getpelican.com/ https://pypi.org/project/pelican/"
SRC_URI="https://github.com/getpelican/pelican/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples markdown test"

DEPEND=">=dev-python/feedgenerator-1.9[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	>=dev-python/six-1.4[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	markdown? ( dev-python/markdown[${PYTHON_USEDEP}] )
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/markdown[${PYTHON_USEDEP}]
	)"
RDEPEND=""
RESTRICT="test"

DOCS=( README.rst )

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

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}
