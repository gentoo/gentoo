# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multilib-minimal

DESCRIPTION="Cryptographic library for embedded systems"
HOMEPAGE="https://www.trustedfirmware.org/projects/mbed-tls/"
SRC_URI="https://github.com/Mbed-TLS/mbedtls/archive/${P}.tar.gz"
S=${WORKDIR}/${PN}-${P}

LICENSE="Apache-2.0"
SLOT="0/12.18.4" # ffmpeg subslot naming: SONAME tuple of {libmbedcrypto.so,libmbedtls.so,libmbedx509.so}
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="cpu_flags_x86_sse2 doc programs static-libs test threads"
RESTRICT="!test? ( test )"

RDEPEND="
	programs? (
		dev-libs/openssl:0=
	)"
DEPEND="${RDEPEND}
	doc? ( app-text/doxygen media-gfx/graphviz )
	test? ( dev-lang/perl )"

enable_mbedtls_option() {
	local myopt="$@"
	# check that config.h syntax is the same at version bump
	sed -i \
		-e "s://#define ${myopt}:#define ${myopt}:" \
		include/mbedtls/mbedtls_config.h || die
}

src_prepare() {
	use cpu_flags_x86_sse2 && enable_mbedtls_option MBEDTLS_HAVE_SSE2
	use threads && enable_mbedtls_option MBEDTLS_THREADING_C
	use threads && enable_mbedtls_option MBEDTLS_THREADING_PTHREAD

	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_PROGRAMS=$(multilib_native_usex programs)
		-DUSE_STATIC_MBEDTLS_LIBRARY=$(usex static-libs)
		-DENABLE_TESTING=$(usex test)
		-DUSE_SHARED_MBEDTLS_LIBRARY=ON
		-DINSTALL_MBEDTLS_HEADERS=ON
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DMBEDTLS_FATAL_WARNINGS=OFF # Don't use -Werror, #744946
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
	use doc && multilib_is_native_abi && cd "${S}" && emake apidoc
}

multilib_src_test() {
	# psa isn't ready yet, even in 3.0.0.
	# bug #718390
	local myctestargs=(
		-E "(psa_crypto|psa_its-suite)"
	)

	LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${BUILD_DIR}/library" \
		cmake_src_test
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
