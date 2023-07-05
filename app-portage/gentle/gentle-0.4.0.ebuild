# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=flit
PYPI_PN="gentle-mxml"
inherit distutils-r1 optfeature pypi

DESCRIPTION="Gentoo Lazy Entry - a metadata.xml generator"
HOMEPAGE="
	https://gentle.sysrq.in
	https://pypi.org/project/gentle-mxml/
"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/lxml[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		app-text/xmldiff[${PYTHON_USEDEP}]
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/pkginfo[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/rdflib[${PYTHON_USEDEP}]
		$(python_gen_cond_dep \
			'dev-python/tomli[${PYTHON_USEDEP}]' 3.10)
	)
"

EPYTEST_DESELECT=(
	# require network
	"tests/python/wheel/test_generator.py::test_pkg_empty[pyproject.toml]"
	"tests/python/wheel/test_generator.py::test_pkg_empty[setup.py]"
)

distutils_enable_tests pytest

distutils_enable_sphinx docs \
	dev-python/insipid-sphinx-theme \
	dev-python/sphinx-prompt

pkg_postinst() {
	optfeature "python packaging support" dev-python/build
	optfeature "PKG-INFO support" dev-python/pkginfo
	optfeature "yaml support" dev-python/pyyaml
	optfeature "rdf support" dev-python/rdflib
	optfeature "toml support" dev-python/tomli
}
