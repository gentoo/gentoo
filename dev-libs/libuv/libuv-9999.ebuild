# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3 multilib-minimal

DESCRIPTION="Cross-platform asychronous I/O"
HOMEPAGE="https://github.com/libuv/libuv"
EGIT_REPO_URI="https://github.com/libuv/libuv"

LICENSE="BSD BSD-2 ISC MIT"
SLOT="0/1"
KEYWORDS=""
IUSE="static-libs"
RESTRICT="test"

BDEPEND="
	sys-devel/libtool
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

src_prepare() {
	default

	echo "m4_define([UV_EXTRA_AUTOMAKE_FLAGS], [serial-tests])" \
		> m4/libuv-extra-automake-flags.m4 || die

	# upstream fails to ship a configure script
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		cc_cv_cflags__g=no
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	mkdir "${BUILD_DIR}"/test || die
	cp -pPR "${S}"/test/fixtures "${BUILD_DIR}"/test/fixtures || die
	default
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
