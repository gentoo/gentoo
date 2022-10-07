# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE='sqlite?,threads(+)'

inherit bash-completion-r1 distutils-r1 optfeature verify-sig

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
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv ~sparc x86 ~x64-macos"
IUSE="doc sqlite test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/asgiref-3.4.1[${PYTHON_USEDEP}]
	>=dev-python/sqlparse-0.2.2[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/backports-zoneinfo[${PYTHON_USEDEP}]
	' 3.8)
"
BDEPEND="
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
		!!<dev-python/ipython-7.21.0-r1
		!!=dev-python/ipython-7.22.0-r0
	)
	verify-sig? ( >=sec-keys/openpgp-keys-django-20201201 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0-bashcomp.patch
	"${FILESDIR}"/django-4.0.5-py311.patch
)

distutils_enable_sphinx docs --no-autodoc

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/django.asc

src_unpack() {
	if use verify-sig; then
		cd "${DISTDIR}" || die
		verify-sig_verify_signed_checksums \
			"${P^}.checksum.txt" sha256 "${P^}.tar.gz"
		cd "${WORKDIR}" || die
	fi

	default
}

src_prepare() {
	# TODO: this suddenly started failing
	sed -i -e 's:test_custom_fields:_&:' tests/inspectdb/tests.py || die

	distutils-r1_src_prepare
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
	optfeature_header "Additional Backend support can be enabled via:"
	optfeature "MySQL backend support" dev-python/mysqlclient
	optfeature "PostgreSQL backend support" dev-python/psycopg:2
	optfeature_header
	optfeature "GEO Django" "sci-libs/gdal[geos]"
	optfeature "Memcached support" dev-python/pylibmc dev-python/python-memcached
	optfeature "ImageField Support" dev-python/pillow
	optfeature "Password encryption" dev-python/bcrypt
	optfeature "High-level abstractions for Django forms" dev-python/django-formtools
}
