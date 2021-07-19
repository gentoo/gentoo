# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="A dynamic Lisp dialect and bytecode vm"
HOMEPAGE="https://janet-lang.org https://github.com/janet-lang/janet/"
SRC_URI="https://github.com/janet-lang/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

MY_RELEASE="${PV::-2}"

PATCHES="${FILESDIR}/janet-1.16.1-make.patch"

src_configure() {
	append-ldflags -Wl,-soname,libjanet.so.1.${MY_RELEASE}
	append-cflags -fPIC
}

src_compile() {
	# janet_build is the git hash of the commit related to the
	# current release - it defines a constant which is then shown
	# when starting janet
	local janet_build='\"'${PV}'\"'
	emake LIBDIR="/usr/$(get_libdir)" PREFIX="/usr" JANET_BUILD="${janet_build}"
	emake LIBDIR="/usr/$(get_libdir)" PREFIX="/usr" build/janet.pc JANET_BUILD="${janet_build}"
	emake LIBDIR="/usr/$(get_libdir)" PREFIX="/usr" docs JANET_BUILD="${janet_build}"
	emake LIBDIR="/usr/$(get_libdir)" PREFIX="/usr" build/jpm JANET_BUILD="${janet_build}"
}

src_install() {
	dobin "build/janet"
	dobin "jpm"
	insinto "usr/include/janet"
	doheader "src/include/janet.h"
	doheader "src/conf/janetconf.h"

	dolib.so "build/libjanet.so"
	dosym libjanet.so /usr/$(get_libdir)/libjanet.so.${MY_RELEASE}
	dosym libjanet.so.${MY_RELEASE} /usr/$(get_libdir)/libjanet.so.${PV}

	if use static-libs; then
		dolib.a "build/libjanet.a"
	fi
	doman "janet.1"
	doman "jpm.1"

	insinto /usr/$(get_libdir)/pkgconfig/
	doins "build/janet.pc"
	dodoc -r examples
	dodoc "build/doc.html"
	# required for jpm
	keepdir /usr/$(get_libdir)/janet/.cache
}

pkg_postinst() {
	elog "Enable use flag \"static-libs\" for building stand-alone executables with jpm"
}
