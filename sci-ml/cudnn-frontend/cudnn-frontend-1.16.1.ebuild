# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cuda cmake edo

DESCRIPTION="A c++ wrapper for the cudnn backend API"
HOMEPAGE="https://github.com/NVIDIA/cudnn-frontend"

SRC_URI="https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="samples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/cudnn-9.0.0:=
"
DEPEND="${RDEPEND}
	dev-cpp/nlohmann_json
	test? (
		>=dev-cpp/catch-3
		>=dev-libs/cudnn-9.15.0
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.11.0-fix.patch"
)

src_prepare() {
	cmake_src_prepare

	sed -e 's#"cudnn_frontend/thirdparty/nlohmann/json.hpp"#<nlohmann/json.hpp>#' \
		-i include/cudnn_frontend_utils.h || die

	rm -r include/cudnn_frontend/thirdparty || die
}

src_configure() {
	local narch
	if use amd64; then
		narch="x86_64"
	elif use arm64; then
		narch="sbsa"
	fi

	local mycmakeargs=(
		-DCUDNN_FRONTEND_BUILD_PYTHON_BINDINGS="no"
		-DCUDNN_FRONTEND_BUILD_SAMPLES="$(usex test "$(usex samples)")"
		-DCUDNN_FRONTEND_BUILD_TESTS="$(usex test)"
		-DCUDNN_FRONTEND_SKIP_JSON_LIB="no"
	)

	if use samples || use test; then
		# allow slotted install
		: "${CUDNN_PATH:=${ESYSROOT}/opt/cuda}"
		export CUDNN_PATH
	fi

	cmake_src_configure
}

src_test() {
	cuda_add_sandbox -w
	addwrite "/proc/self/task"

	# List all tests
	# "${BUILD_DIR}/bin/tests" --list-tests --verbosity quiet

	local catchargs=()

	local CATCH_SKIP_TESTS=()

	if [[ -v CUDAARCHS && "${CUDAARCHS}" != 89 ]]; then
		CATCH_SKIP_TESTS+=(
			 # doesn't work on 86 52
			'Graph key'
			'Graph key dynamic shape'

			 # doesn't work on 86
			'sdpa backward graph serialization'
		)
	fi

	[[ -v CATCH_SKIP_TESTS ]] && catchargs+=( "${CATCH_SKIP_TESTS[@]/#/\~}" )

	edo "${BUILD_DIR}/bin/tests" -s "${catchargs[@]}"

	if use samples; then
		edo "${BUILD_DIR}/bin/samples" -s
		edo "${BUILD_DIR}/bin/legacy_samples" -s
	fi

	cmake_src_test
}

src_install() {
	cmake_src_install

	if use test; then
		rm -R "${ED}/usr/bin/tests" || die
	fi
}
