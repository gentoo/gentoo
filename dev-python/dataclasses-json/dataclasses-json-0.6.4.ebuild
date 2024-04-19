# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="Easily serialize Data Classes to and from JSON"
HOMEPAGE="
	https://pypi.org/project/dataclasses-json/
	https://github.com/lidatong/dataclasses-json
"
SRC_URI="https://github.com/lidatong/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/typing_inspect[${PYTHON_USEDEP}]
	dev-python/marshmallow[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# the normal poetry backend works for us if we fill in the version
	sed -r -i pyproject.toml \
		-e 's:poetry_dynamic_versioning.backend:poetry.core.masonry.api:' \
		-e 's:,[[:space:]]*"poetry-dynamic-versioning"::' \
		-e "s:(version[[:space:]]*=[[:space:]]*)\"[0-9.]*\":\1\"${PV}\":" \
		|| die

	# remove mypy dep for running tests
	rm tests/test_annotations.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	epytest tests
}
