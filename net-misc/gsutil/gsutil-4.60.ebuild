# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="command line tool for interacting with cloud storage services"
HOMEPAGE="https://github.com/GoogleCloudPlatform/gsutil"
SRC_URI="http://commondatastorage.googleapis.com/pub/${PN}_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/argcomplete-1.9.4[${PYTHON_USEDEP}]
	>=dev-python/boto-2.49.0[${PYTHON_USEDEP}]
	>=dev-python/crcmod-1.7[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.14.1[${PYTHON_USEDEP}]
	>=dev-python/gcs-oauth2-boto-plugin-2.7[${PYTHON_USEDEP}]
	>=dev-python/google-apitools-0.5.30[${PYTHON_USEDEP}]
	>=dev-python/google-reauth-python-0.1.0[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.18[${PYTHON_USEDEP}]
	>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/monotonic-1.4[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
	>=dev-python/retry-decorator-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.12.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/gsutil-4.41-tests.patch"
	"${FILESDIR}/gsutil-4.50-boto-tests.patch"
	"${FILESDIR}/gsutil-4.50-tests.patch"
)

S="${WORKDIR}/${PN}"

DOCS=( README.md CHANGES.md )

# needs to talk to Google to run tests
RESTRICT+=" test"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# NB: We don't delete all of boto/ because the tests are imported by the
	# production code.  The same reason we can't delete gslib/tests/.  We can
	# delete the main boto library and use the system version though.
	rm -r gslib/vendored/boto/boto || die

	# failes to compile with py3
	rm gslib/vendored/boto/tests/mturk/cleanup_tests.py || die

	sed -i \
		-e 's/mock==/mock>=/' \
		setup.py || die
	# Sanity check we didn't miss any updates.
	grep '==' setup.py && die "Need to update version requirements"

	# For debugging purposes, temporarily uncomment this in order to
	# show hidden tracebacks.
	#sed -e 's/^  except OSError as e:$/&\n    raise/' \
	#	-e 's/def _HandleUnknownFailure(e):/&\n  raise/' \
	#	-i gslib/__main__.py || die

	# create_bucket raised ResponseNotReady
	sed -i \
		-e 's/test_cp_unwritable_tracker_file/_&/' \
		-e 's/test_cp_unwritable_tracker_file_download/_&/' \
		gslib/tests/test_cp.py || die

	sed -i -E -e 's/(executable_prefix =).*/\1 [sys.executable]/' \
		gslib/commands/test.py || die

	# IOError: close() called during concurrent operation on the same file object.
	sed -i -e 's/sys.stderr.close()/#&/' \
		gslib/tests/testcase/unit_testcase.py || die
}

python_compile() {
	2to3 --write --nobackups --no-diffs -j "$(makeopts_jobs "${MAKEOPTS}" INF)" \
		gslib/vendored/boto/tests || die "2to3 on boto tests failed"

	distutils-r1_python_compile
}

python_test() {
	BOTO_CONFIG="${FILESDIR}/dummy.boto" \
		"${EPYTHON}" gslib/__main__.py test -u || die "tests failed with ${EPYTHON}"
}
