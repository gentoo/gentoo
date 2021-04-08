# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This is the commit that the CI for the release commit used
BINS_COMMIT="a80fd0d56d538d07a05ef01e29c8cb430a4f9d72"

inherit meson

DESCRIPTION="reverse engineering framework for binary analysis"
HOMEPAGE="https://rizin.re/"

SRC_URI="https://github.com/rizinorg/rizin/releases/download/v${PV}/rizin-src-v${PV}.tar.xz
	test? ( https://github.com/rizinorg/rizin-testbins/archive/${BINS_COMMIT}.tar.gz -> rizin-testbins-${BINS_COMMIT}.tar.gz )"
KEYWORDS="~amd64 ~x86"

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

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	default

	if use test; then
	   mv "${WORKDIR}/rizin-testbins-${BINS_COMMIT}" "${S}/test/bins" || die
	fi
}

src_configure() {
	local emesonargs=(
		-Dcli=enabled
		-Duse_sys_capstone=enabled
		-Duse_sys_magic=enabled
		-Duse_sys_zip=enabled
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
