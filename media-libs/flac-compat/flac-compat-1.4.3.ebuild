# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal

DESCRIPTION="Free lossless audio encoder and decoder"
HOMEPAGE="https://xiph.org/flac/"
SRC_URI="https://downloads.xiph.org/releases/${PN/-compat}/${P/-compat}.tar.xz"
S="${WORKDIR}/${P/-compat}"

LICENSE="BSD FDL-1.2 GPL-2 LGPL-2.1"
SLOT="12.1.0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+cxx ogg cpu_flags_x86_avx"

RDEPEND="
	!media-libs/flac:0/10-12
	ogg? ( media-libs/libogg[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	sys-devel/gettext
	virtual/pkgconfig
	abi_x86_32? ( dev-lang/nasm )
"

multilib_src_configure() {
	# -fipa-pta exposes a test failure in replaygain_analysis (https://gcc.gnu.org/PR115533)
	# TODO: Replace with some -ffp-contract= option?
	append-flags $(test-flags-CC -fno-ipa-pta)

	local myeconfargs=(
		--disable-doxygen-docs
		--disable-examples
		--disable-valgrind-testing
		--disable-version-from-git

		$(use_enable cpu_flags_x86_avx avx)
		$(use_enable cxx cpplibs)
		--disable-debug
		$(use_enable ogg)

		--disable-programs

		# cross-compile fix (bug #521446)
		# no effect if ogg support is disabled
		--with-ogg
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	# configure has --enable-exhaustive-tests we could pass...
	# there's also --disable-thorough-test.
	if [[ ${UID} != 0 ]]; then
		# Parallel tests work for CMake but don't for autotools as of 1.4.3
		# https://github.com/xiph/flac/commit/aaffdcaa969c19aee9dc89be420eae470b55e405
		emake -j1 check
	else
		ewarn "Tests will fail if ran as root, skipping."
	fi
}

multilib_src_install_all() {
	rm -r "${ED}"/usr/include || die
	rm -r "${ED}"/usr/share || die
	rm -r "${ED}"/usr/lib*/pkgconfig || die
	rm -r "${ED}"/usr/lib*/*.so || die

	find "${ED}" -type f -name '*.la' -delete || die
}
