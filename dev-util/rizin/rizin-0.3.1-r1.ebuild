# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=(python3_{8,9,10})

# This is the commit that the CI for the release commit used
BINS_COMMIT="74b6e4511112b1a6abc571091efc32ec2a7d98a6"

inherit meson python-any-r1

DESCRIPTION="reverse engineering framework for binary analysis"
HOMEPAGE="https://rizin.re/"

SRC_URI="https://github.com/rizinorg/rizin/releases/download/v${PV}/rizin-src-v${PV}.tar.xz"
	#test? ( https://github.com/rizinorg/rizin-testbins/archive/${BINS_COMMIT}.tar.gz -> rizin-testbins-${BINS_COMMIT}.tar.gz )"
KEYWORDS="~amd64 ~arm64 ~x86"

LICENSE="Apache-2.0 BSD LGPL-3 MIT"
SLOT="0/${PV}"
IUSE="test"

# Need to audit licenses of the binaries used for testing
RESTRICT="test"

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
	"${FILESDIR}/${PN}-0.3.0-typedb-prefix.patch"
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
	# Rizin uses data files that it expects to be installed on the
	# system. To hack around this, we create a tree of what it expects
	# in ${T}, and patch the tests to support a prefix from the
	# environment. https://github.com/rizinorg/rizin/issues/1789
	mkdir -p "${T}/usr/share/${PN}/${PV}" || die
	ln -sf "${BUILD_DIR}/librz/analysis/d" "${T}/usr/share/${PN}/${PV}/types" || die
	ln -sf "${BUILD_DIR}/librz/syscall/d" "${T}/usr/share/${PN}/${PV}/syscall" || die
	ln -sf "${BUILD_DIR}/librz/asm/d" "${T}/usr/share/${PN}/${PV}/opcodes" || die
	# https://github.com/rizinorg/rizin/issues/1797
	ln -sf "${BUILD_DIR}/librz/flag/d" "${T}/usr/share/${PN}/${PV}/flag" || die
	export RZ_PREFIX="${T}/usr"

	meson_src_test
}
