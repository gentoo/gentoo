# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib dot-a

DESCRIPTION="Access a working SSH implementation by means of a library"
HOMEPAGE="https://www.libssh.org/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.libssh.org/projects/libssh.git"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libssh.asc
	inherit verify-sig
	SRC_URI="
		https://www.libssh.org/files/$(ver_cut 1-2)/${P}.tar.xz
		verify-sig? ( https://www.libssh.org/files/$(ver_cut 1-2)/${P}.tar.xz.asc )
	"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-libssh )"
fi

LICENSE="LGPL-2.1"
SLOT="0/4" # subslot = soname major version
IUSE="debug doc examples gssapi mbedtls pcap server +sftp static-libs test zlib"
# Maintainer: check IUSE-defaults at DefineOptions.cmake
RESTRICT="!test? ( test )"

RDEPEND="
	!mbedtls? ( >=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}] )
	gssapi? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
	mbedtls? ( net-libs/mbedtls:3=[${MULTILIB_USEDEP},threads] )
	zlib? ( >=virtual/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-util/cmocka-0.3.1[${MULTILIB_USEDEP}]
		elibc_musl? ( sys-libs/argp-standalone )
	)
"
BDEPEND+=" doc? ( app-text/doxygen[dot] )"

DOCS=( AUTHORS CHANGELOG README )

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		return
	fi

	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.xz{,.asc}
	fi

	default
}

src_prepare() {
	# Remove custom find module to use system one
	rm cmake/Modules/FindMbedTLS.cmake || die

	cmake_src_prepare

	# just install the examples, do not compile them
	cmake_comment_add_subdirectory examples

	sed -e "/^check_include_file.*HAVE_VALGRIND_VALGRIND_H/s/^/#DONT /" \
		-i ConfigureChecks.cmake || die

	if use test; then
		local skip_tests=(
			# keyfile torture test is currently broken
			-e "/torture_keyfiles/d"

			# Tries to expand ~ which fails w/ portage homedir
			# (torture_path_expand_tilde_unix and torture_config_make_absolute_no_sshdir)
			-e "/torture_misc/d"
			-e "/torture_config/d"
		)

		# Disable tests that take too long (bug #677006)
		if use sparc; then
			skip_tests+=(
				-e "/torture_threads_pki_rsa/d"
				-e "/torture_pki_dsa/d"
			)
		fi

		if (( ${#skip_tests[@]} )) ; then
			sed -i "${skip_tests[@]}" tests/unittests/CMakeLists.txt || die
		fi

		if use elibc_musl; then
			sed -e "/SOLARIS/d" \
				-i tests/CMakeLists.txt || die
		fi
	fi
}

src_configure() {
	lto-guarantee-fat
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local mycmakeargs=(
		-DWITH_NACL=OFF
		-DWITH_STACK_PROTECTOR=OFF
		-DWITH_STACK_PROTECTOR_STRONG=OFF
		-DWITH_DEBUG_CALLTRACE=$(usex debug)
		-DWITH_DEBUG_CRYPTO=$(usex debug)
		# Deprecated per CMakeLists.txt
		-DWITH_GCRYPT=OFF
		-DWITH_GSSAPI=$(usex gssapi)
		-DWITH_MBEDTLS=$(usex mbedtls)
		-DMBEDTLS_FOUND=$(usex mbedtls) # Enforce variable from custom find module
		-DWITH_PCAP=$(usex pcap)
		-DWITH_SERVER=$(usex server)
		-DWITH_SFTP=$(usex sftp)
		-DBUILD_STATIC_LIB=$(usex static-libs)
		# TODO: try enabling {CLIENT,SERVER}_TESTING
		-DUNIT_TESTING=$(usex test)
		-DWITH_ZLIB=$(usex zlib)
	)

	multilib_is_native_abi || mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON )

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
	multilib_is_native_abi && use doc && cmake_src_compile docs
}

multilib_src_test() {
	cmake_src_test --timeout 3000
}

multilib_src_install() {
	cmake_src_install
	multilib_is_native_abi && use doc && local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )

	use static-libs && dolib.a src/libssh.a

	# compatibility symlink until all consumers have been updated
	# to no longer use libssh_threads.so
	dosym libssh.so /usr/$(get_libdir)/libssh_threads.so
}

multilib_src_install_all() {
	strip-lto-bytecode
	use mbedtls && DOCS+=( README.mbedtls )
	einstalldocs

	if use examples; then
		docinto examples
		dodoc examples/*.{c,h,cpp}
	fi
}
