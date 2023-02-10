# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal toolchain-funcs usr-ldscript

DESCRIPTION="zstd fast compression library"
HOMEPAGE="https://facebook.github.io/zstd/"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+lzma lz4 static-libs zlib"

RDEPEND="
	lzma? ( app-arch/xz-utils )
	lz4? ( app-arch/lz4 )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	multilib_copy_sources
}

mymake() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		V=1 \
		HAVE_LZMA="$(multilib_native_usex lzma 1 0)" \
		HAVE_LZ4="$(multilib_native_usex lz4 1 0)" \
		HAVE_ZLIB="$(multilib_native_usex zlib 1 0)" \
		"${@}"
}

multilib_src_compile() {
	local libzstd_targets=( libzstd{,.a}-mt )

	mymake -C lib ${libzstd_targets[@]} libzstd.pc

	if multilib_is_native_abi ; then
		mymake zstd
		mymake -C contrib/pzstd
	fi
}

multilib_src_test() {
	if multilib_is_native_abi ; then
		# 'test' runs more tests than 'check'.
		mymake -C tests test
		mymake -C contrib/pzstd test
	else
		mymake check
	fi
}

multilib_src_install() {
	mymake -C lib DESTDIR="${D}" install

	if multilib_is_native_abi ; then
		mymake -C programs DESTDIR="${D}" install

		gen_usr_ldscript -a zstd

		mymake -C contrib/pzstd DESTDIR="${D}" install
	fi
}

multilib_src_install_all() {
	einstalldocs

	if ! use static-libs; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
