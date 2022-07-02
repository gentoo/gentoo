# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A dynamic Lisp dialect and bytecode vm"
HOMEPAGE="https://janet-lang.org https://github.com/janet-lang/janet/"
SRC_URI="https://github.com/janet-lang/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

MY_RELEASE="${PV::-2}"

src_configure() {
	tc-export CC

	append-ldflags -Wl,-soname,libjanet.so.1.${MY_RELEASE}
	append-cflags -fPIC
}

src_compile() {
	# janet_build is the git hash of the commit related to the
	# current release - it defines a constant which is then shown
	# when starting janet
	local janet_build='\"'${PV}'\"'

	local target
	for target in '' build/janet.pc docs ; do
		einfo "Building: ${target:-main}"
		emake \
			LIBDIR="/usr/$(get_libdir)" \
			PREFIX="/usr" \
			JANET_BUILD="${janet_build}" \
			CFLAGS="${CFLAGS}" \
			LDFLAGS="${LDFLAGS}" \
			${target}
	done
}

src_install() {
	dobin build/janet

	insinto /usr/include/janet
	doheader src/include/janet.h
	doheader src/conf/janetconf.h

	dolib.so build/libjanet.so
	dosym libjanet.so /usr/$(get_libdir)/libjanet.so.${MY_RELEASE}
	dosym libjanet.so.${MY_RELEASE} /usr/$(get_libdir)/libjanet.so.${PV}

	if use static-libs; then
		dolib.a build/libjanet.a
	fi

	doman janet.1

	insinto /usr/$(get_libdir)/pkgconfig/
	doins build/janet.pc

	dodoc -r examples
	dodoc build/doc.html
}

pkg_postinst() {
	elog "Note: jpm has been extracted to its own repository upstream."
	elog "Follow the upstream instructions on how to install it."
	elog "Enable use flag \"static-libs\" for building stand-alone executables with jpm"
}
