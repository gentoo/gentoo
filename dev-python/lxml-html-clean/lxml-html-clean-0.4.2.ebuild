# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Separate project for HTML cleaning functionalities copied from lxml.html.clean"
HOMEPAGE="
	https://github.com/fedora-python/lxml_html_clean/
	https://pypi.org/project/lxml-html-clean/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64"

RDEPEND="
	>=dev-python/lxml-5.2.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_test() {
	eunittest
	"${EPYTHON}" -m doctest -v tests/*.txt ||
		die "Doctests failed on ${EPYTHON}"
}
