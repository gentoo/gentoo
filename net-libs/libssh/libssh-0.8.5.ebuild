# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${PN}-${PV/_rc/rc}"
inherit cmake-multilib

DESCRIPTION="Access a working SSH implementation by means of a library"
HOMEPAGE="https://www.libssh.org/"

if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.libssh.org/projects/libssh.git"
else
	inherit eapi7-ver
	SRC_URI="https://www.libssh.org/files/$(ver_cut 1-2)/${MY_P}.tar.xz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ia64 ~mips ~ppc ~ppc64 ~s390 sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2.1"
SLOT="0/4" # subslot = soname major version
IUSE="debug doc examples gcrypt gssapi libressl mbedtls pcap server +sftp static-libs test zlib"
# Maintainer: check IUSE-defaults at DefineOptions.cmake

REQUIRED_USE="?? ( gcrypt mbedtls ) test? ( static-libs )"

RDEPEND="
	!gcrypt? (
		!mbedtls? (
			!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}] )
			libressl? ( dev-libs/libressl:=[${MULTILIB_USEDEP}] )
		)
	)
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0[${MULTILIB_USEDEP}] )
	gssapi? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
	mbedtls? ( net-libs/mbedtls[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
	test? ( >=dev-util/cmocka-0.3.1[${MULTILIB_USEDEP}] )
"

DOCS=( AUTHORS README ChangeLog )

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-0.8.0-tests.patch"
	"${FILESDIR}/${PN}-0.8.3-strict-overflow.patch"
)

src_prepare() {
	cmake-utils_src_prepare

	# just install the examples, do not compile them
	cmake_comment_add_subdirectory examples

	# keyfile torture test is currently broken
	sed -i \
		-e '/torture_keyfiles/d' \
		tests/unittests/CMakeLists.txt || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DUNIT_TESTING="$(usex test)"
		-DWITH_DEBUG_CALLTRACE="$(usex debug)"
		-DWITH_DEBUG_CRYPTO="$(usex debug)"
		-DWITH_GCRYPT="$(usex gcrypt)"
		-DWITH_GSSAPI="$(usex gssapi)"
		-DWITH_MBEDTLS="$(usex mbedtls)"
		-DWITH_NACL=no
		-DWITH_PCAP="$(usex pcap)"
		-DWITH_SERVER="$(usex server)"
		-DWITH_SFTP="$(usex sftp)"
		-DWITH_STACK_PROTECTOR=OFF
		-DWITH_STACK_PROTECTOR_STRONG=OFF
		-DWITH_STATIC_LIB="$(usex static-libs)"
		-DWITH_ZLIB="$(usex zlib)"
	)

	multilib_is_native_abi || mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON )

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
	multilib_is_native_abi && use doc && cmake-utils_src_compile docs
}

multilib_src_install() {
	cmake-utils_src_install
	use doc && HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )

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
