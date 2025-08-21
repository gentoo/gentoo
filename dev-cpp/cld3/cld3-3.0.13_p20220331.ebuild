# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Neural network model for language identification"
HOMEPAGE="https://github.com/google/cld3"

MY_PV="b48dc46512566f5a2d41118c8c1116c4f96dc661"
SRC_URI="https://github.com/google/cld3/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~loong"

RDEPEND="
	dev-cpp/abseil-cpp:=
	dev-libs/protobuf:=
"
DEPEND="${RDEPEND}"

src_prepare() {
	# None of the added compiler flags make sense or are future-proof
	sed -e '/add_definitions(/d' \
		-i CMakeLists.txt || die

	# Specify the c++ standard through cmake's heurestics instead
	cat >> CMakeLists.txt <<- 'EOF' || die
	set(CMAKE_CXX_STANDARD 17)
	EOF

	# Link with the right libraries for the tests
	cat >> CMakeLists.txt <<- 'EOF' || die
	target_link_libraries(cld3
		protobuf-lite
		absl_log_internal_check_op
		absl_log_internal_message
	)
	EOF

	# Let cmake actually know about the tests
	cat >> CMakeLists.txt <<- 'EOF' || die
	include(CTest)
	add_test(NAME language_identifier_main COMMAND language_identifier_main)
	add_test(NAME getonescriptspan_test COMMAND getonescriptspan_test)
	add_test(NAME language_identifier_features_test COMMAND language_identifier_features_test)
	EOF

	# Install the library
	cat >> CMakeLists.txt <<- 'EOF' || die
	include(GNUInstallDirs)
	install(TARGETS cld3)
	install(FILES
		src/base.h
		src/casts.h
		src/embedding_feature_extractor.h
		src/embedding_network.h
		src/embedding_network_params.h
		src/feature_extractor.h
		src/feature_types.h
		src/float16.h
		src/lang_id_nn_params.h
		src/language_identifier_features.h
		src/nnet_language_identifier.h
		src/registry.h
		src/sentence_features.h
		src/task_context.h
		src/task_context_params.h
		src/utils.h
		src/workspace.h
		DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/cld3")
	install(FILES
		src/script_span/generated_ulscript.h
		src/script_span/getonescriptspan.h
		src/script_span/integral_types.h
		src/script_span/offsetmap.h
		src/script_span/stringpiece.h
		DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/cld3/script_span")
	install(FILES
		"${CMAKE_CURRENT_BINARY_DIR}/cld_3/protos/feature_extractor.pb.h"
		"${CMAKE_CURRENT_BINARY_DIR}/cld_3/protos/sentence.pb.h"
		"${CMAKE_CURRENT_BINARY_DIR}/cld_3/protos/task_spec.pb.h"
		DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/cld3/cld_3/protos")
	EOF

	cmake_src_prepare
}
