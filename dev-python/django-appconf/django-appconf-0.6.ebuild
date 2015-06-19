# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-appconf/django-appconf-0.6.ebuild,v 1.9 2015/04/18 12:58:59 swegener Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A helper class for handling configuration defaults of packaged apps gracefully"
HOMEPAGE="https://github.com/jezdez/django-appconf http://django-appconf.readthedocs.org/"
SRC_URI="https://github.com/jezdez/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 x86"
IUSE="doc test"

LICENSE="BSD"
SLOT="0"

RDEPEND=">=dev-python/django-1.4.1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/django-discover-runner[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/docs.patch )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	cd appconf/tests || die
	set -- django-admin.py test appconf --settings=appconf.test_settings
	echo "$@"
	"$@" || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
