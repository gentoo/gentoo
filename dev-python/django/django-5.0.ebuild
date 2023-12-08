# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE='sqlite?,threads(+)'

inherit bash-completion-r1 distutils-r1 multiprocessing optfeature verify-sig

DESCRIPTION="High-level Python web framework"
HOMEPAGE="
	https://www.djangoproject.com/
	https://github.com/django/django/
	https://pypi.org/project/Django/
"
SRC_URI="
	https://media.djangoproject.com/releases/$(ver_cut 1-2)/${P^}.tar.gz
	verify-sig? ( https://media.djangoproject.com/pgp/${P^}.checksum.txt )
"
S="${WORKDIR}/${P^}"

LICENSE="BSD"
# admin fonts: Roboto (media-fonts/roboto)
LICENSE+=" Apache-2.0"
# admin icons, jquery, xregexp.js
LICENSE+=" MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
IUSE="doc sqlite test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/asgiref-3.7.0[${PYTHON_USEDEP}]
	>=dev-python/sqlparse-0.3.1[${PYTHON_USEDEP}]
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
	verify-sig? ( >=sec-keys/openpgp-keys-django-20230606 )
"

PATCHES=(
	"${FILESDIR}"/django-4.0-bashcomp.patch
)

distutils_enable_sphinx docs --no-autodoc

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/django.asc

src_unpack() {
	if use verify-sig; then
		cd "${DISTDIR}" || die
		verify-sig_verify_signed_checksums \
			"${P^}.checksum.txt" sha256 "${P^}.tar.gz"
		cd "${WORKDIR}" || die
	fi

	default
}

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
	optfeature "PostgreSQL backend support" dev-python/psycopg:2
	optfeature_header
	optfeature "GEO Django" "sci-libs/gdal[geos]"
	optfeature "Memcached support" dev-python/pylibmc dev-python/python-memcached
	optfeature "ImageField Support" dev-python/pillow
	optfeature "Password encryption" dev-python/bcrypt
}
