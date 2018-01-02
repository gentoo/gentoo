# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib git-r3

DESCRIPTION="Access a working SSH implementation by means of a library"
HOMEPAGE="https://www.libssh.org/"
EGIT_REPO_URI="https://git.libssh.org/projects/libssh.git"

LICENSE="LGPL-2.1"
KEYWORDS=""
SLOT="0"
IUSE="debug doc examples gcrypt gssapi libressl pcap server +sftp ssh1 static-libs test zlib"
# Maintainer: check IUSE-defaults at DefineOptions.cmake

RDEPEND="
	!gcrypt? (
		!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl[${MULTILIB_USEDEP}] )
	)
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0[${MULTILIB_USEDEP}] )
	gssapi? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( >=dev-util/cmocka-0.3.1[${MULTILIB_USEDEP}] )
"

DOCS=( AUTHORS README ChangeLog )

EGIT_MIN_CLONE_TYPE=single

src_prepare() {
	cmake-utils_src_prepare

	# just install the examples do not compile them
	sed -i \
		-e '/add_subdirectory(examples)/s/^/#DONOTWANT/' \
		CMakeLists.txt || die

}

multilib_src_configure() {
	local mycmakeargs=(
		-DWITH_DEBUG_CALLTRACE="$(usex debug)"
		-DWITH_DEBUG_CRYPTO="$(usex debug)"
		-DWITH_GCRYPT="$(usex gcrypt)"
		-DWITH_GSSAPI="$(usex gssapi)"
		-DWITH_NACL=no
		-DWITH_PCAP="$(usex pcap)"
		-DWITH_SERVER="$(usex server)"
		-DWITH_SFTP="$(usex sftp)"
		-DWITH_SSH1="$(usex ssh1)"
		-DWITH_STATIC_LIB="$(usex static-libs)"
		-DWITH_STATIC_LIB="$(usex test)"
		-DWITH_TESTING="$(usex test)"
		-DWITH_ZLIB="$(usex zlib)"
	)

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
	multilib_is_native_abi && use doc && cmake-utils_src_compile doc
}

multilib_src_install() {
	cmake-utils_src_install

	if multilib_is_native_abi && use doc ; then
		docinto html
		dodoc -r doc/html/.
	fi

	use static-libs || rm -f "${D}"/usr/$(get_libdir)/libssh{,_threads}.a
}

multilib_src_install_all() {
	einstalldocs

	if use examples; then
		docinto examples
		dodoc examples/*.{c,h,cpp}
	fi
}
