# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1

DESCRIPTION="Gherkin parser/compiler for Python"
HOMEPAGE="https://github.com/cucumber/gherkin/"
SRC_URI="
	https://github.com/cucumber/gherkin/archive/refs/tags/v${PV}.tar.gz
		-> gherkin-${PV}.gh.tar.gz
"
S=${WORKDIR}/gherkin-${PV}/python

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_install() {
	distutils-r1_python_install

	# dev-python/pytest-bdd tests currently fail without this
	python_moduleinto gherkin
	python_domodule ../gherkin-languages.json
}
