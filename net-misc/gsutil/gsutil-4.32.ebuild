# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="command line tool for interacting with cloud storage services"
HOMEPAGE="https://github.com/GoogleCloudPlatform/gsutil"
SRC_URI="http://commondatastorage.googleapis.com/pub/${PN}_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	>=dev-python/argcomplete-1.9.4[${PYTHON_USEDEP}]
	>=dev-python/boto-2.48.0[${PYTHON_USEDEP}]
	>=dev-python/crcmod-1.7[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.14.1[${PYTHON_USEDEP}]
	>=dev-python/gcs-oauth2-boto-plugin-2.1[${PYTHON_USEDEP}]
	>=dev-python/google-apitools-0.5.22[${PYTHON_USEDEP}]
	dev-python/google-reauth-python[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.11.3[${PYTHON_USEDEP}]
	>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/monotonic-1.4[${PYTHON_USEDEP}]
	>=dev-python/oauth2client-4.1.2[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
	>=dev-python/python-gflags-2.0[${PYTHON_USEDEP}]
	>=dev-python/retry-decorator-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/PySocks-1.01[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${PN}

DOCS=( README.md CHANGES.md )

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -e 's/boto==/boto>=/' \
		-e 's/mock==/mock>=/' \
		-e 's/oauth2client==/oauth2client>=/' \
		-e 's/SocksiPy-branch==/PySocks>=/' \
		-i setup.py || die

	# For debugging purposes, temporarily uncomment this in order to
	# show hidden tracebacks.
	#sed -e 's/^  except OSError as e:$/&\n    raise/' \
	#	-e 's/def _HandleUnknownFailure(e):/&\n  raise/' \
	#	-i gslib/__main__.py || die

	# create_bucket raised ResponseNotReady
	sed -e 's/test_cp_unwritable_tracker_file/_&/' \
		-e 's/test_cp_unwritable_tracker_file_download/_&/' \
		-i gslib/tests/test_cp.py || die

	sed -e 's/\(executable_prefix =\).*/\1 [sys.executable]/' \
		-i gslib/commands/test.py || die

	# IOError: close() called during concurrent operation on the same file object.
	sed -e 's/sys.stderr.close()/#&/' \
		-i gslib/tests/testcase/unit_testcase.py

	# Package installs 'test' package which is forbidden and likely a bug in the build system
	rm -rf "${S}/test" || die
	sed -i -e '/recursive-include test/d' MANIFEST.in || die
}

python_test() {
	export BOTO_CONFIG=${FILESDIR}/dummy.boto
	${PYTHON} gslib/__main__.py test -u || die "tests failed"
}
