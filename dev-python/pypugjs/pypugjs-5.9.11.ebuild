# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 optfeature

DESCRIPTION="Pug (Jade) syntax adapter for Django, Jinja2 and Mako templates"
HOMEPAGE="https://github.com/kakulukia/pypugjs"
SRC_URI="https://github.com/kakulukia/pypugjs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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
		>=dev-python/tornado-6.0.4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests nose

src_prepare() {
	# Remove pyramid backend as pyramid isn't packaged
	rm -r pypugjs/ext/pyramid || die
	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "converting to Django output" dev-python/django
	optfeature "converting to Jinja2 output" dev-python/jinja
	optfeature "converting to Mako output" dev-python/mako
	optfeature "converting to Tornado output" dev-python/tornado
}
