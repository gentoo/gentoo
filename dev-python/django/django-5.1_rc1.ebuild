# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN^}
PYTHON_COMPAT=( pypy3 python3_{10..13} )
PYTHON_REQ_USE='sqlite?,threads(+)'

inherit bash-completion-r1 distutils-r1 multiprocessing optfeature pypi

DESCRIPTION="High-level Python web framework"
HOMEPAGE="
	https://www.djangoproject.com/
	https://github.com/django/django/
	https://pypi.org/project/Django/
"

LICENSE="BSD"
# admin fonts: Roboto (media-fonts/roboto)
LICENSE+=" Apache-2.0"
# admin icons, jquery, xregexp.js
LICENSE+=" MIT"
SLOT="0"
IUSE="doc sqlite test"
RESTRICT="!test? ( test )"

RDEPEND="
	<dev-python/asgiref-4[${PYTHON_USEDEP}]
	>=dev-python/asgiref-3.8.1[${PYTHON_USEDEP}]
	>=dev-python/sqlparse-0.3.1[${PYTHON_USEDEP}]
	sys-libs/timezone-data
"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		${RDEPEND}
		>=dev-python/docutils-0.19[${PYTHON_USEDEP}]
		>=dev-python/jinja-2.11.0[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[webp,${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		>=dev-python/selenium-4.8.0[${PYTHON_USEDEP}]
		>=dev-python/tblib-1.5.0[${PYTHON_USEDEP}]
		sys-devel/gettext
	)
"

PATCHES=(
	"${FILESDIR}"/django-4.0-bashcomp.patch
)

distutils_enable_sphinx docs --no-autodoc

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/django.asc

python_test() {
	# Tests have non-standard assumptions about PYTHONPATH,
	# and don't work with ${BUILD_DIR}/lib.
	PYTHONPATH=. "${EPYTHON}" tests/runtests.py --settings=test_sqlite \
		-v2 --parallel="${EPYTEST_JOBS:-$(makeopts_jobs)}" ||
		die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	newbashcomp extras/django_bash_completion ${PN}-admin
	bashcomp_alias ${PN}-admin django-admin.py

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature_header "Additional Backend support can be enabled via:"
	optfeature "MySQL backend support" dev-python/mysqlclient
	optfeature "PostgreSQL backend support" dev-python/psycopg:0
	optfeature_header
	optfeature "GEO Django" "sci-libs/gdal[geos]"
	optfeature "Memcached support" dev-python/pylibmc dev-python/python-memcached
	optfeature "ImageField Support" dev-python/pillow
	optfeature "Password encryption" dev-python/bcrypt
}
