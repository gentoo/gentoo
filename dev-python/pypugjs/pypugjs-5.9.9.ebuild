# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 optfeature

DESCRIPTION="Pug (Jade) syntax adapter for Django, Jinja2 and Mako templates"
HOMEPAGE="https://github.com/kakulukia/pypugjs"
SRC_URI="https://github.com/kakulukia/pypugjs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/mako[${PYTHON_USEDEP}]
		www-servers/tornado[${PYTHON_USEDEP}]
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
	optfeature "converting to Tornado output" www-servers/tornado
}
