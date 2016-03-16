# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_P=${PN}-${PV/_rc/rc}
inherit eutils cmake-multilib multilib

DESCRIPTION="Access a working SSH implementation by means of a library"
HOMEPAGE="http://www.libssh.org/"
SRC_URI="https://red.libssh.org/attachments/download/195/${MY_P}.tar.xz -> ${P}.tar.xz"

LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ppc ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
SLOT="0/4" # subslot = soname major version
IUSE="debug doc examples gcrypt gssapi libressl pcap +sftp ssh1 server static-libs test zlib"
# Maintainer: check IUSE-defaults at DefineOptions.cmake

RDEPEND="
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	!gcrypt? (
		!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl[${MULTILIB_USEDEP}] )
	)
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0[${MULTILIB_USEDEP}] )
	gssapi? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( >=dev-util/cmocka-0.3.1[${MULTILIB_USEDEP}] )
"

DOCS=( AUTHORS README ChangeLog )

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.0-tests.patch
)

src_prepare() {
	# just install the examples do not compile them
	sed -i \
		-e '/add_subdirectory(examples)/s/^/#DONOTWANT/' \
		CMakeLists.txt || die

	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DWITH_DEBUG_CALLTRACE="$(usex debug)"
		-DWITH_DEBUG_CRYPTO="$(usex debug)"
		-DWITH_gcrypt="$(usex gcrypt)"
		-DWITH_gssapi="$(usex gssapi)"
		-DWITH_pcap="$(usex pcap)"
		-DWITH_server="$(usex server)"
		-DWITH_sftp="$(usex sftp)"
		-DWITH_ssh1="$(usex ssh1)"
		-DWITH_STATIC_LIB="$(usex static-libs)"
		-DWITH_STATIC_LIB="$(usex test)"
		-DWITH_TESTING="$(usex test)"
		-DWITH_zlib="$(usex zlib)"
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
