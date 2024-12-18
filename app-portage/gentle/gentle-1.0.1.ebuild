# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
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

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	sys-apps/portage[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		app-text/xmldiff[${PYTHON_USEDEP}]
		dev-lang/perl
		dev-lang/ruby:*
		>=dev-python/build-1.2.0[${PYTHON_USEDEP}]
		dev-python/pkginfo[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/rdflib[${PYTHON_USEDEP}]
		dev-python/uv
	)
"

distutils_enable_tests pytest

distutils_enable_sphinx docs \
	dev-python/insipid-sphinx-theme \
	dev-python/sphinx-prompt

python_test() {
	epytest --with-perl --with-ruby
}

pkg_postinst() {
	optfeature "python packaging support" "dev-python/build dev-python/uv"
	optfeature "PKG-INFO support" dev-python/pkginfo
	optfeature "yaml support" dev-python/pyyaml
	optfeature "rdf support" dev-python/rdflib
}
