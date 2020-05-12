# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE='sqlite?,threads(+)'

inherit bash-completion-r1 distutils-r1 eutils

MY_PN="Django"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="High-level Python web framework"
HOMEPAGE="https://www.djangoproject.com/ https://pypi.org/project/Django/"
SRC_URI="https://www.djangoproject.com/m/releases/$(ver_cut 1-2)/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
# admin fonts: Roboto (media-fonts/roboto)
LICENSE+=" Apache-2.0"
# admin icons, jquery, xregexp.js
LICENSE+=" MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc sqlite test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/asgiref[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/sqlparse-0.2.2[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[webp,${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/selenium[${PYTHON_USEDEP}]
		dev-python/tblib[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.6-bashcomp.patch
)

distutils_enable_sphinx docs

python_test() {
	# Tests have non-standard assumptions about PYTHONPATH,
	# and don't work with ${BUILD_DIR}/lib.
	PYTHONPATH=. "${EPYTHON}" tests/runtests.py --settings=test_sqlite -v2 ||
		die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	newbashcomp extras/django_bash_completion ${PN}-admin
	bashcomp_alias ${PN}-admin django-admin.py

	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "Additional Backend support can be enabled via"
	optfeature "MySQL backend support" dev-python/mysqlclient
	optfeature "PostgreSQL backend support" dev-python/psycopg:2
	echo ""
	elog "Other features can be enhanced by"
	optfeature "GEO Django" "sci-libs/gdal[geos]"
	optfeature "Memcached support" dev-python/pylibmc dev-python/python-memcached
	optfeature "ImageField Support" dev-python/pillow
	optfeature "Password encryption" dev-python/bcrypt
	optfeature "High-level abstractions for Django forms" dev-python/django-formtools
}
