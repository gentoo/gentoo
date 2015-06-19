# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/flask-restful/flask-restful-0.3.3.ebuild,v 1.1 2015/05/26 06:46:30 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Simple framework for creating REST APIs"
HOMEPAGE="http://flask-restful.readthedocs.org/ https://github.com/twilio/flask-restful/"
SRC_URI="https://github.com/twilio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples paging test"

RDEPEND="
	>=dev-python/aniso8601-0.82[${PYTHON_USEDEP}]
	>=dev-python/flask-0.8[${PYTHON_USEDEP}]
	>=dev-python/six-1.3.0[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	paging? ( >=dev-python/pycrypto-2.6[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-python/sphinx[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pycrypto[${PYTHON_USEDEP}]
	)
"

python_test() {
	nosetests -v || die "Tests fail with ${EPYTHON}"
}

python_compile_all() {
	cd docs || die
	emake man $(usex doc html "")
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && local EXAMPLES=( examples/. )
	local DOCS=( AUTHORS.md CHANGES.md CONTRIBUTING.md README.md )

	doman docs/_build/man/*
	distutils-r1_python_install_all
}
