# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

# This is the commit that the CI for the release commit used
BINS_COMMIT="1203a9a2f51e32337c8434d9f4f7c4543552e271"

inherit meson python-any-r1

DESCRIPTION="reverse engineering framework for binary analysis"
HOMEPAGE="https://rizin.re/"

SRC_URI="mirror+https://github.com/rizinorg/rizin/releases/download/v${PV}/rizin-src-v${PV}.tar.xz
	test? ( https://github.com/rizinorg/rizin-testbins/archive/${BINS_COMMIT}.tar.gz -> rizin-testbins-${BINS_COMMIT}.tar.gz )"
KEYWORDS="~amd64 ~arm64 ~x86"

LICENSE="Apache-2.0 BSD LGPL-3 MIT"
SLOT="0/${PV}"
IUSE="test"

# Need to audit licenses of the binaries used for testing
RESTRICT="test? ( fetch ) !test? ( test )"

# TODO: unbundle dev-libs/blake3
RDEPEND="
	app-arch/lz4:0=
	app-arch/xz-utils
	app-arch/zstd:=
	>=dev-libs/capstone-5:0=
	dev-libs/libmspack
	dev-libs/libzip:0=
	dev-libs/openssl:0=
	dev-libs/libpcre2:0=
	>=dev-libs/tree-sitter-0.19.0
	dev-libs/xxhash
	sys-apps/file
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
		sys/clang-format.py
		test/fuzz/scripts/fuzz_rz_asm.py
		test/scripts/gdbserver.py
	)

	python_fix_shebang "${py_to_mangle[@]}"

	# https://github.com/rizinorg/rizin/issues/3459
	sed -ie '/dyld_chained_ptr_arm64e_auth/d' test/unit/test_bin_mach0.c || die

	if use test; then
		cp -r "${WORKDIR}/rizin-testbins-${BINS_COMMIT}" "${S}/test/bins" || die
		cp -r "${WORKDIR}/rizin-testbins-${BINS_COMMIT}" "${S}" || die
	fi
}

src_configure() {
	local emesonargs=(
		-Dcli=enabled
		-Duse_sys_capstone=enabled
		-Duse_sys_libmspack=enabled
		-Duse_sys_libzip=enabled
		-Duse_sys_libzstd=enabled
		-Duse_sys_lz4=enabled
		-Duse_sys_lzma=enabled
		-Duse_sys_magic=enabled
		-Duse_sys_openssl=enabled
		-Duse_sys_pcre2=enabled
		-Duse_sys_tree_sitter=enabled
		-Duse_sys_xxhash=enabled
		-Duse_sys_zlib=enabled

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
