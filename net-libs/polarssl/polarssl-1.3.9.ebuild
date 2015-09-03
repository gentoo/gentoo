# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib cmake-utils multilib-minimal

DESCRIPTION="Cryptographic library for embedded systems"
HOMEPAGE="http://polarssl.org/"
SRC_URI="http://polarssl.org/download/${P}-gpl.tgz"

LICENSE="GPL-2"
SLOT="0/7"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="doc havege programs cpu_flags_x86_sse2 static-libs test threads zlib"

RDEPEND="
	programs? ( dev-libs/openssl:0 )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen media-gfx/graphviz )
	test? ( dev-lang/perl )"

enable_polarssl_option() {
	local myopt="$@"
	# check that config.h syntax is the same at version bump
	sed -i \
		-e "s://#define ${myopt}:#define ${myopt}:" \
		include/polarssl/config.h || die
}

src_prepare() {
	use cpu_flags_x86_sse2 && enable_polarssl_option POLARSSL_HAVE_SSE2
	use zlib && enable_polarssl_option POLARSSL_ZLIB_SUPPORT
	use havege && enable_polarssl_option POLARSSL_HAVEGE_C
	use threads && enable_polarssl_option POLARSSL_THREADING_C
	use threads && enable_polarssl_option POLARSSL_THREADING_PTHREAD

	epatch "${FILESDIR}"/${PN}-1.3.9-respect-cflags.patch
}

multilib_src_configure() {
	local mycmakeargs=(
		$(multilib_is_native_abi && cmake-utils_use_enable programs PROGRAMS \
			|| echo -DENABLE_PROGRAMS=OFF)
		$(cmake-utils_use_enable zlib ZLIB_SUPPORT)
		$(cmake-utils_use_use static-libs STATIC_POLARSSL_LIBRARY)
		$(cmake-utils_use_enable test TESTING)
		-DUSE_SHARED_POLARSSL_LIBRARY=ON
		-DINSTALL_POLARSSL_HEADERS=ON
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
	einstalldocs

	use doc && dohtml -r apidoc

	if use programs ; then
		# avoid file collisions with sys-apps/coreutils
		local p e
		for p in "${ED%/}"/usr/bin/* ; do
			if [[ -x "${p}" && ! -d "${p}" ]] ; then
				mv "${p}" "${ED%/}"/usr/bin/polarssl_${p##*/} || die
			fi
		done
		for e in aes hash pkey ssl test ; do
			docinto "${e}"
			dodoc programs/"${e}"/*.c
			dodoc programs/"${e}"/*.txt
		done
	fi
}
