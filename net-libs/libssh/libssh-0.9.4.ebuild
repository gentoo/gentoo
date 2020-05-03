# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="Access a working SSH implementation by means of a library"
HOMEPAGE="https://www.libssh.org/"

if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.libssh.org/projects/libssh.git"
else
	SRC_URI="https://www.libssh.org/files/$(ver_cut 1-2)/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2.1"
SLOT="0/4" # subslot = soname major version
IUSE="debug doc examples gcrypt gssapi libressl mbedtls pcap server +sftp static-libs test zlib"
# Maintainer: check IUSE-defaults at DefineOptions.cmake

REQUIRED_USE="?? ( gcrypt mbedtls )"

BDEPEND="
	doc? ( app-doc/doxygen[dot] )
"
RDEPEND="
	!gcrypt? (
		!mbedtls? (
			!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}] )
			libressl? ( dev-libs/libressl:=[${MULTILIB_USEDEP}] )
		)
	)
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0[${MULTILIB_USEDEP}] )
	gssapi? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
	mbedtls? ( net-libs/mbedtls:=[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	test? ( >=dev-util/cmocka-0.3.1[${MULTILIB_USEDEP}] )
"

DOCS=( AUTHORS README ChangeLog )

PATCHES=( "${FILESDIR}/${PN}-0.8.0-tests.patch" )

RESTRICT+=" !test? ( test )"

src_prepare() {
	cmake_src_prepare

	# just install the examples, do not compile them
	cmake_comment_add_subdirectory examples

	# keyfile torture test is currently broken
	sed -e "/torture_keyfiles/d" \
		-i tests/unittests/CMakeLists.txt || die

	# disable tests that take too long (bug #677006)
	if use sparc; then
		sed -e "/torture_threads_pki_rsa/d" -e "/torture_pki_dsa/d" \
			-i tests/unittests/CMakeLists.txt || die
	fi

	sed -e "/^check_include_file.*HAVE_VALGRIND_VALGRIND_H/s/^/#DONT /" \
		-i ConfigureChecks.cmake || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DWITH_NACL=OFF
		-DWITH_STACK_PROTECTOR=OFF
		-DWITH_STACK_PROTECTOR_STRONG=OFF
		-DWITH_DEBUG_CALLTRACE="$(usex debug)"
		-DWITH_DEBUG_CRYPTO="$(usex debug)"
		-DWITH_GCRYPT="$(usex gcrypt)"
		-DWITH_GSSAPI="$(usex gssapi)"
		-DWITH_MBEDTLS="$(usex mbedtls)"
		-DWITH_PCAP="$(usex pcap)"
		-DWITH_SERVER="$(usex server)"
		-DWITH_SFTP="$(usex sftp)"
		-DBUILD_STATIC_LIB="$(usex static-libs)"
		-DUNIT_TESTING="$(usex test)"
		-DWITH_ZLIB="$(usex zlib)"
	)

	multilib_is_native_abi || mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON )

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
	multilib_is_native_abi && use doc && cmake_src_compile docs
}

multilib_src_install() {
	cmake_src_install
	multilib_is_native_abi && use doc && HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )

	use static-libs && dolib.a src/libssh.a

	# compatibility symlink until all consumers have been updated
	# to no longer use libssh_threads.so
	dosym libssh.so /usr/$(get_libdir)/libssh_threads.so
}

multilib_src_install_all() {
	use mbedtls && DOCS+=( README.mbedtls )
	einstalldocs

	if use examples; then
		docinto examples
		dodoc examples/*.{c,h,cpp}
	fi
}
