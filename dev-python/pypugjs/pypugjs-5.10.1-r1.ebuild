# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 optfeature

DESCRIPTION="Pug (Jade) syntax adapter for Django, Jinja2 and Mako templates"
HOMEPAGE="
	https://github.com/kakulukia/pypugjs/
	https://pypi.org/project/pypugjs/
"
SRC_URI="
	https://github.com/kakulukia/pypugjs/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/six-1.15.0[${PYTHON_USEDEP}]
	>=dev-python/chardet-4.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/django[${PYTHON_USEDEP}]
		>=dev-python/jinja-3.1.1[${PYTHON_USEDEP}]
		>=dev-python/mako-1.1.3[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		>=dev-python/tornado-6.0.4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# poetry nonsense
	sed -i -e 's:\^:>=:' pyproject.toml || die
	# upstream hardcodes wrong version, and puts test dependencies
	# in regular depenendencies, so discard the whole thing
	sed -e "/version/s:5\.9\.12:${PV}:" \
		-e 's:tool\.poetry\.dependencies:tool.poetry.group.ignored.dependencies:' \
		-i pyproject.toml || die

	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "converting to Django output" dev-python/django
	optfeature "converting to Jinja2 output" dev-python/jinja
	optfeature "converting to Mako output" dev-python/mako
	optfeature "converting to Tornado output" dev-python/tornado
}
