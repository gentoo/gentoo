# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This is the commit that the CI for the release commit used
BINS_COMMIT="b7d6c0ec57eb1c14e970b8301f36cbac997ee695"

inherit meson

DESCRIPTION="reverse engineering framework for binary analysis"
HOMEPAGE="https://rizin.re/"

SRC_URI="https://github.com/rizinorg/rizin/releases/download/v${PV}/rizin-src-${PV}.tar.xz
	test? ( https://github.com/rizinorg/rizin-testbins/archive/${BINS_COMMIT}.tar.gz -> rizin-testbins-${BINS_COMMIT}.tar.gz )"
KEYWORDS="~amd64"

LICENSE="Apache-2.0 BSD LGPL-3 MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-apps/file
	app-arch/lz4:0=
	dev-libs/capstone:0=
	dev-libs/libuv:0=
	dev-libs/libzip:0=
	dev-libs/openssl:0=
	dev-libs/tree-sitter
	dev-libs/xxhash
	sys-libs/zlib:0=
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	if use test; then
	   mv "${WORKDIR}/rizin-testbins-${BINS_COMMIT}" "${S}/test/bins" || die
	fi
}

src_configure() {
	local emesonargs=(
		-Dcli=enabled
		-Duse_sys_capstone=true
		-Duse_sys_magic=true
		-Duse_sys_zip=true
		-Duse_sys_zlib=true
		-Duse_sys_lz4=true
		-Duse_sys_xxhash=true
		-Duse_sys_openssl=true
		-Duse_sys_tree_sitter=true

		$(meson_use test enable_tests)
		$(meson_use test enable_rz_test)
	)
	meson_src_configure
}
