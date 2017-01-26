# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils multilib-minimal

DESCRIPTION="Cryptographic library for embedded systems"
HOMEPAGE="https://tls.mbed.org/"
SRC_URI="https://tls.mbed.org/download/mbedtls-2.4.0-apache.tgz"

LICENSE="Apache-2.0"
SLOT="0/10" # slot for libmbedtls.so
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="cpu_flags_x86_sse2 doc havege libressl programs test threads zlib"

RDEPEND="
	programs? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen media-gfx/graphviz )
	test? ( dev-lang/perl )"

enable_mbedtls_option() {
	local myopt="$@"
	# check that config.h syntax is the same at version bump
	sed -i \
		-e "s://#define ${myopt}:#define ${myopt}:" \
		include/mbedtls/config.h || die
}

src_prepare() {
	use cpu_flags_x86_sse2 && enable_mbedtls_option MBEDTLS_HAVE_SSE2
	use zlib && enable_mbedtls_option MBEDTLS_ZLIB_SUPPORT
	use havege && enable_mbedtls_option MBEDTLS_HAVEGE_C
	use threads && enable_mbedtls_option MBEDTLS_THREADING_C
	use threads && enable_mbedtls_option MBEDTLS_THREADING_PTHREAD

	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_PROGRAMS=$(multilib_native_usex programs)
		-DENABLE_ZLIB_SUPPORT=$(usex zlib)
		-DUSE_STATIC_MBEDTLS_LIBRARY=OFF
		-DENABLE_TESTING=$(usex test)
		-DUSE_SHARED_MBEDTLS_LIBRARY=ON
		-DINSTALL_MBEDTLS_HEADERS=ON
		-DLIB_INSTALL_DIR="/usr/$(get_libdir)"
	)

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
	use doc && multilib_is_native_abi && emake apidoc
}

multilib_src_test() {
	LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${BUILD_DIR}/library" \
		cmake-utils_src_test
}

multilib_src_install() {
	cmake-utils_src_install
}

multilib_src_install_all() {
	use doc && HTML_DOCS=( apidoc )

	einstalldocs

	if use programs ; then
		# avoid file collisions with sys-apps/coreutils
		local p e
		for p in "${ED%/}"/usr/bin/* ; do
			if [[ -x "${p}" && ! -d "${p}" ]] ; then
				mv "${p}" "${ED%/}"/usr/bin/mbedtls_${p##*/} || die
			fi
		done
		for e in aes hash pkey ssl test ; do
			docinto "${e}"
			dodoc programs/"${e}"/*.c
			dodoc programs/"${e}"/*.txt
		done
	fi
}
