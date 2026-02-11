# Copyright 2008-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Default implementation currently is upb, which doesn't match dev-libs/protobuf
# https://github.com/protocolbuffers/protobuf/blob/main/python/README.md#implementation-backends

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

GH_PV=$(ver_cut 2-3)
GH_P=${PN}-${GH_PV}

DESCRIPTION="Google's Protocol Buffers - Python bindings"
HOMEPAGE="
	https://protobuf.dev/
	https://pypi.org/project/protobuf/
"
# Rename sdist to avoid conflicts with dev-libs/protobuf
SRC_URI="
	$(pypi_sdist_url) -> ${P}.py.tar.gz
	test? (
		https://github.com/protocolbuffers/protobuf/archive/v${GH_PV}.tar.gz
			-> ${GH_P}.gh.tar.gz
	)
"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-3)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

# need protobuf compiler
BDEPEND="
	test? (
		dev-libs/protobuf[protoc(+)]
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_unpack() {
	unpack "${P}.py.tar.gz"

	if use test; then
		mkdir "${WORKDIR}/test" || die
		cd "${WORKDIR}/test" || die
		unpack "${GH_P}.gh.tar.gz"
	fi
}

src_prepare() {
	distutils-r1_src_prepare

	# strip old-style namespace
	rm google/__init__.py || die
}

python_test() {
	local EPYTEST_DESELECT=()
	local EPYTEST_IGNORE=(
		# TODO: figure out how to build the pybind11 test extension
		google/protobuf/internal/recursive_message_pybind11_test.py
	)

	case ${EPYTHON} in
		python3.11)
			EPYTEST_IGNORE+=(
				# syntax error...
				google/protobuf/internal/json_format_test.py
			)
			;;
		python3.14*)
			EPYTEST_DESELECT+=(
				# exception message mismatch
				google/protobuf/internal/json_format_test.py::JsonFormatTest::testInvalidTimestamp
				google/protobuf/internal/well_known_types_test.py::TimeUtilTest::testInvalidTimestamp
			)
			;;
	esac

	cp -r "${BUILD_DIR}"/{install,test} || die
	local -x PATH="${BUILD_DIR}/test${EPREFIX}/usr/bin:${PATH}"
	cd "${BUILD_DIR}/test$(python_get_sitedir)" || die

	# copy test files from the source tree
	cp -r "${WORKDIR}/test/${GH_P}/python/google/protobuf/internal/." \
		google/protobuf/internal/ || die
	# link the test data for text_format_test.py
	# (it traverses directories upwards until to finds src/google...)
	ln -s "${WORKDIR}/test/${GH_P}/src" ../src || die

	# compile test-related protobufs
	local test_protos=(
		# from src
		any_test.proto
		map_proto2_unittest.proto
		map_unittest.proto
		unittest.proto
		unittest_custom_options.proto
		unittest_delimited.proto
		unittest_delimited_import.proto
		unittest_features.proto
		unittest_import.proto
		unittest_import_option.proto
		unittest_import_public.proto
		unittest_legacy_features.proto
		unittest_mset.proto
		unittest_mset_wire_format.proto
		unittest_no_field_presence.proto
		unittest_no_generic_services.proto
		unittest_proto3.proto
		unittest_proto3_arena.proto
		unittest_proto3_extensions.proto
		unittest_retention.proto
		util/json_format.proto
		util/json_format_proto3.proto
		# from python
		internal/descriptor_pool_test1.proto
		internal/descriptor_pool_test2.proto
		internal/factory_test1.proto
		internal/factory_test2.proto
		internal/file_options_test.proto
		internal/import_test_package/import_public.proto
		internal/import_test_package/import_public_nested.proto
		internal/import_test_package/inner.proto
		internal/import_test_package/outer.proto
		internal/message_set_extensions.proto
		internal/missing_enum_values.proto
		internal/more_extensions.proto
		internal/more_messages.proto
		internal/no_package.proto
		internal/packed_field_test.proto
		internal/self_recursive.proto
		internal/test_bad_identifiers.proto
		internal/test_proto2.proto
		internal/test_proto3_optional.proto
		internal/well_known_types_test.proto
	)
	local proto
	for proto in "${test_protos[@]}"; do
		protoc --python_out=. -I"${WORKDIR}/test/${GH_P}/src" -I. \
			"google/protobuf/${proto}" || die
	done

	epytest
}
