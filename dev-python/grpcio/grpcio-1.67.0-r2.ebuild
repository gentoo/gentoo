# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 flag-o-matic multiprocessing pypi

MY_P=grpc-${PV}
DESCRIPTION="HTTP/2-based RPC framework"
HOMEPAGE="
	https://grpc.io/
	https://github.com/grpc/grpc/
	https://pypi.org/project/grpcio/
"
# Tests need other packages from the source tree, so use a GitHub
# archive.  sdist provides bundled library sources (git submodules).
SRC_URI+="
	test? (
		https://github.com/grpc/grpc/archive/v${PV}.tar.gz
			-> ${MY_P}.gh.tar.gz
		$(pypi_sdist_url grpcio_tools)
	)
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/openssl:=
	net-dns/c-ares:=
	sys-libs/zlib:=
"
RDEPEND="
	${DEPEND}
"
# TODO: try to remove coverage dep
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		>=dev-python/protobuf-python-5.26.1[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_configure() {
	export GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS="$(makeopts_jobs)"
	# system abseil-cpp crashes with USE=-debug, sigh
	# https://bugs.gentoo.org/942021
	#export GRPC_PYTHON_BUILD_SYSTEM_ABSL=1
	export GRPC_PYTHON_BUILD_SYSTEM_CARES=1
	export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
	# re2 needs to be built against the same abseil-cpp version
	#export GRPC_PYTHON_BUILD_SYSTEM_RE2=1
	export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1

	# copied from setup.py, except for removed -std= that does not apply
	# to C code and causes warnings
	export GRPC_PYTHON_CFLAGS="-fvisibility=hidden -fno-wrapv -fno-exceptions"
	# required by abseil-cpp
	append-cxxflags -std=c++14
	# silence a lot of harmless noise from bad quality code
	append-cxxflags -Wno-attributes
}

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		tests/unit/_dns_resolver_test.py::DNSResolverTest::test_connect_loopback
		# not a test
		tests_aio/unit/channel_argument_test.py::test_if_reuse_port_enabled
	)
	local EPYTEST_IGNORE=(
		# not a test
		tests/unit/test_common.py
		# requires oauth2client
		tests/unit/beta/_implementations_test.py
	)
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1

	cp -a "${BUILD_DIR}"/{install,test} || die
	local -x PATH=${BUILD_DIR}/test/usr/bin:${PATH}

	# grpcio proper builds against system libs
	# grpcio_tools supports bundled libs only, and requires different
	# flags
	unset GRPC_PYTHON_CFLAGS
	cd "${WORKDIR}/grpcio_tools-${PV}" || die
	distutils_pep517_install "${BUILD_DIR}"/test

	cd "${WORKDIR}/${MY_P}" || die
	local protodir=src/proto/grpc/testing
	local testdir=src/python/grpcio_tests
	"${EPYTHON}" -m grpc_tools.protoc -I. --python_out="${testdir}" \
		"${protodir}"/{empty,messages}.proto || die
	"${EPYTHON}" -m grpc_tools.protoc -I. --grpc_python_out="${testdir}" \
		"${protodir}"/test.proto || die

	cd "${testdir}" || die
	"${EPYTHON}" -m grpc_tools.protoc -I. --python_out=. \
		tests/testing/proto/{requests,services}.proto || die
	"${EPYTHON}" -m grpc_tools.protoc -I. --grpc_python_out=. \
		tests/testing/proto/services.proto || die

	# TODO: aio tests are failing randomly, so we're skipping them entirely
	epytest tests{_py3_only,}/unit
}
