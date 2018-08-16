# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="A flexible and capable API layer for django utilising serialisers"
HOMEPAGE="https://pypi.org/project/django-tastypie/ https://github.com/toastdriven/django-tastypie"
SRC_URI="https://github.com/toastdriven/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 x86"
IUSE="bip doc test"

LICENSE="BSD"
SLOT="0"

COMMON_DEPEND=">=dev-python/mimeparse-0.1.4[${PYTHON_USEDEP}]
		!~dev-python/mimeparse-1.5[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-1.5[${PYTHON_USEDEP}]
		!~dev-python/python-dateutil-2.0[${PYTHON_USEDEP}]
		>=dev-python/django-1.7[${PYTHON_USEDEP}]
		<dev-python/django-1.10[${PYTHON_USEDEP}]"

RDEPEND="${COMMON_DEPEND}
		bip? ( dev-python/biplist[${PYTHON_USEDEP}] )"

# test: django fails at current version of sci-libs/geos, making tests
# explode immediately
DEPEND="
	${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/biplist[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/defusedxml[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/mock-1.1.0[${PYTHON_USEDEP}]' python2_7)
		>=dev-python/pytz-2013b[${PYTHON_USEDEP}]
		!!sci-libs/geos[python] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/mock-1.1.0[${PYTHON_USEDEP}]' python2_7)
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}] )"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	cd tests || die
	# keep in sync with tox.ini
	django-admin.py test -v 2 -p '*' core.tests --settings=settings_core ||
		die "core.tests fail with ${EPYTHON}"
	django-admin.py test -v 2 basic.tests --settings=settings_basic ||
		die "basic.tests fail with ${EPYTHON}"
	django-admin.py test -v 2 related_resource.tests --settings=settings_related ||
		die "related_resource.tests fail with ${EPYTHON}"
	django-admin.py test -v 2 alphanumeric.tests --settings=settings_alphanumeric ||
		die "alphanumeric.tests fail with ${EPYTHON}"
	django-admin.py test -v 2 authorization.tests --settings=settings_authorization ||
		die "authorization.tests fail with ${EPYTHON}"
	django-admin.py test -v 2 content_gfk.tests --settings=settings_content_gfk ||
		die "content_gfk.tests fail with ${EPYTHON}"
	django-admin.py test -v 2 customuser.tests --settings=settings_customuser ||
		die "customuser.tests fail with ${EPYTHON}"
	django-admin.py test -v 2 namespaced.tests --settings=settings_namespaced ||
		die "namespaced.tests fail with ${EPYTHON}"
	django-admin.py test -v 2 slashless.tests --settings=settings_slashless ||
		die "slashless.tests fail with ${EPYTHON}"
	django-admin.py test -v 2 validation.tests --settings=settings_validation ||
		die "validation.tests fail with ${EPYTHON}"
#		requires dev-python/geos but django fails at the current version of it
#	django-admin.py test -v 2 gis.tests --settings=settings_gis_spatialite ||
#		die "gis.tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
