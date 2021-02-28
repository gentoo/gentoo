# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE='sqlite?,threads(+)'

inherit bash-completion-r1 distutils-r1 optfeature verify-sig

MY_P=${P^}
DESCRIPTION="High-level Python web framework"
HOMEPAGE="https://www.djangoproject.com/ https://pypi.org/project/Django/"
SRC_URI="
	https://media.djangoproject.com/releases/$(ver_cut 1-2)/${MY_P}.tar.gz
	verify-sig? ( https://media.djangoproject.com/pgp/${MY_P}.checksum.txt )"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
# admin fonts: Roboto (media-fonts/roboto)
LICENSE+=" Apache-2.0"
# admin icons, jquery, xregexp.js
LICENSE+=" MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~sparc x86 ~x64-macos"
IUSE="doc sqlite test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/asgiref[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/sqlparse-0.2.2[${PYTHON_USEDEP}]"
BDEPEND="
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		$(python_gen_impl_dep sqlite)
		${RDEPEND}
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[webp,${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/selenium[${PYTHON_USEDEP}]
		dev-python/tblib[${PYTHON_USEDEP}]
		sys-devel/gettext
	)
	verify-sig? ( >=app-crypt/openpgp-keys-django-20201201 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1-bashcomp.patch
)

distutils_enable_sphinx docs --no-autodoc

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/django.asc

src_unpack() {
	if use verify-sig; then
		cd "${DISTDIR}" || die
		verify-sig_verify_signed_checksums \
			"${MY_P}.checksum.txt" sha256 "${MY_P}.tar.gz"
		cd "${WORKDIR}" || die
	fi

	default
}

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
	elog
	elog "Other features can be enhanced by"
	optfeature "GEO Django" "sci-libs/gdal[geos]"
	optfeature "Memcached support" dev-python/pylibmc dev-python/python-memcached
	optfeature "ImageField Support" dev-python/pillow
	optfeature "Password encryption" dev-python/bcrypt
	optfeature "High-level abstractions for Django forms" dev-python/django-formtools
}
