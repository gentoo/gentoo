# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..14} )

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
KEYWORDS="amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/six-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/charset-normalizer-3.4.4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/django-4.2.25[${PYTHON_USEDEP}]
		>=dev-python/flask-2.3.3[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.1.6[${PYTHON_USEDEP}]
		>=dev-python/mako-1.3.10[${PYTHON_USEDEP}]
		>=dev-python/tornado-6.5.2[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

src_prepare() {
	# poetry nonsense
	sed -i -e 's:\^:>=:' pyproject.toml || die
	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "converting to Django output" dev-python/django
	optfeature "converting to Jinja2 output" dev-python/jinja2
	optfeature "converting to Mako output" dev-python/mako
	optfeature "converting to Tornado output" dev-python/tornado
}
