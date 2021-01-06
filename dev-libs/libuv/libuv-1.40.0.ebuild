# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools multilib-minimal

DESCRIPTION="Cross-platform asychronous I/O"
HOMEPAGE="https://github.com/libuv/libuv"
SRC_URI="https://github.com/libuv/libuv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD BSD-2 ISC MIT"
SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"
RESTRICT="test"

BDEPEND="
	sys-devel/libtool
	virtual/pkgconfig
"

src_prepare() {
	default

	echo "m4_define([UV_EXTRA_AUTOMAKE_FLAGS], [serial-tests])" \
		> m4/libuv-extra-automake-flags.m4 || die

	if [[ ${CHOST} == *-darwin* && ${CHOST##*darwin} -le 9 ]] ; then
		sed -i -e '/!defined(__DragonFly__)/i!defined(__APPLE__) && \\' \
			src/unix/udp.c || die
		sed -i -e '/err = pthread_setname_np/cerr = 0;' \
			src/unix/darwin-proctitle.c || die
		sed -i -e '/int uv_if_indextoname/i\
		static size_t strnlen(char *x, size_t len) {\
			char *r = memchr(x, '"'"'\\n'"'"', len);\
			if (r == NULL)\
				return len;\
			else\
				return r - x;\
		}' \
			src/unix/getaddrinfo.c || die
	fi

	# upstream fails to ship a configure script
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		cc_cv_cflags__g=no
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	mkdir "${BUILD_DIR}"/test || die
	cp -pPR "${S}"/test/fixtures "${BUILD_DIR}"/test/fixtures || die
	default
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
