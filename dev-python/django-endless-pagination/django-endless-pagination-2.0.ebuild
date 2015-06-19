# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-endless-pagination/django-endless-pagination-2.0.ebuild,v 1.4 2015/03/08 23:44:20 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Tools supporting ajax, multiple and lazy pagination, Twitter-style and Digg-style pagination"
HOMEPAGE="https://github.com/frankban/django-endless-pagination"
SRC_URI="https://github.com/frankban/django-endless-pagination/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

RDEPEND=">=dev-python/django-1.3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/django-nose[${PYTHON_USEDEP}]
		dev-python/ipdb[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/selenium[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/xvfbwrapper[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	unset PYTHONPATH
	"${PYTHON}" tests/manage.py test || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( "${S}"/doc/_build/html/. )

	#rm all OSX fork files, Bug #450842
	pushd "${ED}" > /dev/null
	rm -f $(find . -name "._*")
	distutils-r1_python_install_all
}
