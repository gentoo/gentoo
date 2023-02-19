# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

# This is the commit that the CI for the release commit used
BINS_COMMIT="aef7f7b714a696f382f55b8cbbf94c5b69518de3"

inherit meson python-any-r1

DESCRIPTION="reverse engineering framework for binary analysis"
HOMEPAGE="https://rizin.re/"

SRC_URI="mirror+https://github.com/rizinorg/rizin/releases/download/v${PV}/rizin-src-v${PV}.tar.xz
	test? ( https://github.com/rizinorg/rizin-testbins/archive/${BINS_COMMIT}.tar.gz -> rizin-testbins-${BINS_COMMIT}.tar.gz )"
KEYWORDS="amd64 ~arm64 ~x86"

LICENSE="Apache-2.0 BSD LGPL-3 MIT"
SLOT="0/${PV}"
IUSE="test"

# Need to audit licenses of the binaries used for testing
RESTRICT="!test? ( test )"

RDEPEND="
	sys-apps/file
	app-arch/lz4:0=
	dev-libs/capstone:0=
	dev-libs/libuv:0=
	dev-libs/libzip:0=
	dev-libs/openssl:0=
	>=dev-libs/tree-sitter-0.19.0
	dev-libs/xxhash
	sys-libs/zlib:0=
"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}/${PN}-0.4.0-never-rebuild-parser.patch"
)

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	default

	local py_to_mangle=(
		librz/core/cmd_descs/cmd_descs_generate.py
		subprojects/lz4-1.9.3/contrib/meson/meson/GetLz4LibraryVersion.py
		subprojects/lz4-1.9.3/contrib/meson/meson/InstallSymlink.py
		subprojects/lz4-1.9.3/tests/test-lz4-list.py
		subprojects/lz4-1.9.3/tests/test-lz4-speed.py
		subprojects/lz4-1.9.3/tests/test-lz4-versions.py
		sys/clang-format.py
		test/fuzz/scripts/fuzz_rz_asm.py
		test/scripts/gdbserver.py
	)

	python_fix_shebang "${py_to_mangle[@]}"

	if use test; then
		cp -r "${WORKDIR}/rizin-testbins-${BINS_COMMIT}" "${S}/test/bins" || die
		cp -r "${WORKDIR}/rizin-testbins-${BINS_COMMIT}" "${S}" || die
	fi
}

src_configure() {
	local emesonargs=(
		-Dcli=enabled
		-Duse_sys_capstone=enabled
		-Duse_sys_magic=enabled
		-Duse_sys_libzip=enabled
		-Duse_sys_zlib=enabled
		-Duse_sys_lz4=enabled
		-Duse_sys_xxhash=enabled
		-Duse_sys_openssl=enabled
		-Duse_sys_tree_sitter=enabled

		$(meson_use test enable_tests)
		$(meson_use test enable_rz_test)
	)
	meson_src_configure
}

src_test() {
	# We can select running either unit or integration tests, or all of
	# them by not passing --suite. According to upstream, integration
	# tests are more fragile and unit tests are sufficient for testing
	# packaging, so only run those.
	meson_src_test --suite unit
}
