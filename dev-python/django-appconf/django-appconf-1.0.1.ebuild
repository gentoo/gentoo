# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="A helper class for handling configuration defaults of packaged apps gracefully"
HOMEPAGE="
	https://github.com/jezdez/django-appconf
	https://django-appconf.readthedocs.io/en/latest/
	https://pypi.org/project/django-appconf/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="
	>=dev-python/django-1.4.1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	"

PATCHES=( "${FILESDIR}"/docs.patch )

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
