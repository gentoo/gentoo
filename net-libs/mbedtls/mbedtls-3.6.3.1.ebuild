# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit cmake flag-o-matic multilib-minimal python-any-r1

DESCRIPTION="Cryptographic library for embedded systems"
HOMEPAGE="https://www.trustedfirmware.org/projects/mbed-tls/"
SRC_URI="https://github.com/Mbed-TLS/mbedtls/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="|| ( Apache-2.0 GPL-2+ )"
SLOT="3/16.21.7" # ffmpeg subslot naming: SONAME tuple of {libmbedcrypto.so,libmbedtls.so,libmbedx509.so}
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="cpu_flags_x86_sse2 doc programs static-libs test threads"
RESTRICT="!test? ( test )"

RDEPEND="
	!>net-libs/mbedtls-3:0
	programs? ( !net-libs/mbedtls:0[programs] )
"
BDEPEND="
	${PYTHON_DEPS}
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
	test? ( dev-lang/perl )
"

PATCHES=(
	"${FILESDIR}/mbedtls-3.6.2-allow-install-headers-to-different-location.patch"
	"${FILESDIR}/mbedtls-3.6.3.1-add-version-suffix-for-all-installable-targets.patch"
	"${FILESDIR}/mbedtls-3.6.2-add-version-suffix-for-pkg-config-files.patch"
	"${FILESDIR}/mbedtls-3.6.2-exclude-static-3dparty.patch"
	"${FILESDIR}/mbedtls-3.6.3.1-slotted-version.patch"
)

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

	sed -i -e "s:VERSION 3.5.1:VERSION 3.10:g" CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# Workaround for https://github.com/Mbed-TLS/mbedtls/issues/9814
	# (https://github.com/Mbed-TLS/mbedtls/pull/10179, bug #946544)
	append-flags $(test-flags-CC -fzero-init-padding-bits=unions)
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_PROGRAMS=$(multilib_native_usex programs)
		-DENABLE_TESTING=$(usex test)
		-DENABLE_SLOTTED_VERSION=ON
		-DINSTALL_MBEDTLS_HEADERS=ON
		-DCMAKE_INSTALL_INCLUDEDIR="include/mbedtls3"
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
