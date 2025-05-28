# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit cmake flag-o-matic multilib-minimal python-any-r1

DESCRIPTION="Cryptographic library for embedded systems"
HOMEPAGE="https://www.trustedfirmware.org/projects/mbed-tls/"
SRC_URI="https://github.com/Mbed-TLS/mbedtls/releases/download/${P}/${P}.tar.bz2"
LICENSE="|| ( Apache-2.0 GPL-2+ )"
SLOT="0/7.14.1" # ffmpeg subslot naming: SONAME tuple of {libmbedcrypto.so,libmbedtls.so,libmbedx509.so}
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="cmac cpu_flags_x86_sse2 doc havege programs static-libs test threads zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	programs? ( !net-libs/mbedtls:3[programs] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
	test? ( dev-lang/perl )
"

enable_mbedtls_option() {
	local myopt="$@"
	# check that config.h syntax is the same at version bump
	sed -i \
		-e "s://#define ${myopt}:#define ${myopt}:" \
		include/mbedtls/config.h || die
}

src_prepare() {
	use cmac && enable_mbedtls_option MBEDTLS_CMAC_C
	use cpu_flags_x86_sse2 && enable_mbedtls_option MBEDTLS_HAVE_SSE2
	use zlib && enable_mbedtls_option MBEDTLS_ZLIB_SUPPORT
	use havege && enable_mbedtls_option MBEDTLS_HAVEGE_C
	use threads && enable_mbedtls_option MBEDTLS_THREADING_C
	use threads && enable_mbedtls_option MBEDTLS_THREADING_PTHREAD

	sed -i -e "s:VERSION 2.8.12:VERSION 3.10:g" CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# Workaround for https://github.com/Mbed-TLS/mbedtls/issues/9814 (bug #946544)
	append-flags $(test-flags-CC -fzero-init-padding-bits=unions)

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_PROGRAMS=$(multilib_native_usex programs)
		-DENABLE_TESTING=$(usex test)
		-DENABLE_ZLIB_SUPPORT=$(usex zlib)
		-DINSTALL_MBEDTLS_HEADERS=ON
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DLINK_WITH_PTHREAD=$(usex threads)
		-DMBEDTLS_FATAL_WARNINGS=OFF # Don't use -Werror, #744946
		-DUSE_SHARED_MBEDTLS_LIBRARY=ON
		-DUSE_STATIC_MBEDTLS_LIBRARY=$(usex static-libs)
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
	use doc && multilib_is_native_abi && emake -C "${S}" apidoc
}

multilib_src_test() {
	# Disable parallel run, bug #718390
	# https://github.com/Mbed-TLS/mbedtls/issues/4980
	LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${BUILD_DIR}/library" \
		cmake_src_test -j1
}

multilib_src_install() {
	cmake_src_install
}

multilib_src_install_all() {
	use doc && HTML_DOCS=( apidoc )

	einstalldocs

	if use programs ; then
		# avoid file collisions with sys-apps/coreutils
		local p e
		for p in "${ED}"/usr/bin/* ; do
			if [[ -x "${p}" && ! -d "${p}" ]] ; then
				mv "${p}" "${ED}"/usr/bin/mbedtls_${p##*/} || die
			fi
		done
		for e in aes hash pkey ssl test ; do
			docinto "${e}"
			dodoc programs/"${e}"/*.c
			dodoc programs/"${e}"/*.txt
		done
	fi
}
