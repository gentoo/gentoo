# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libssh/libssh-0.6.5.ebuild,v 1.9 2015/05/30 10:53:33 maekke Exp $

EAPI=5

MY_P=${PN}-${PV/_rc/rc}
inherit eutils cmake-multilib multilib

DESCRIPTION="Access a working SSH implementation by means of a library"
HOMEPAGE="http://www.libssh.org/"
SRC_URI="https://red.libssh.org/attachments/download/121/${MY_P}.tar.xz -> ${P}.tar.xz
	https://git.libssh.org/projects/libssh.git/patch/?id=6e0dee7845cea22f59bd353ef42b31cb67170030 -> ${PN}-0.6.5-compilefix.patch"

LICENSE="LGPL-2.1"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
SLOT="0/4" # subslot = soname major version
IUSE="debug doc examples gcrypt gssapi pcap +sftp ssh1 server static-libs test zlib"
# Maintainer: check IUSE-defaults at DefineOptions.cmake

RDEPEND="
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	!gcrypt? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] )
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
	"${DISTDIR}"/${P}-compilefix.patch
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
		$(cmake-utils_use_with debug DEBUG_CALLTRACE)
		$(cmake-utils_use_with debug DEBUG_CRYPTO)
		$(cmake-utils_use_with gcrypt)
		$(cmake-utils_use_with gssapi)
		$(cmake-utils_use_with pcap)
		$(cmake-utils_use_with server)
		$(cmake-utils_use_with sftp)
		$(cmake-utils_use_with ssh1)
		$(cmake-utils_use_with static-libs STATIC_LIB)
		$(cmake-utils_use_with test STATIC_LIB)
		$(cmake-utils_use_with test TESTING)
		$(cmake-utils_use_with zlib)
	)

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
	multilib_is_native_abi && use doc && cmake-utils_src_compile doc
}

multilib_src_install() {
	cmake-utils_src_install

	multilib_is_native_abi && use doc && dohtml -r doc/html/.

	use static-libs || rm -f "${D}"/usr/$(get_libdir)/libssh{,_threads}.a
}

multilib_src_install_all() {
	einstalldocs

	if use examples; then
		docinto examples
		dodoc examples/*.{c,h,cpp}
	fi
}
