# Copyright 2020 Gentoo Authors
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

PATCHES=(
	"${FILESDIR}/${P}"-fix-ldflags-in-pkgconfig.patch
)

src_configure() {
	append-ldflags -Wl,-soname,libjanet.so.0
}

src_compile() {
	# janet_build is the git hash of the commit related to the
	# current release - it defines a constant which is then shown
	# when starting janet
	local janet_build='\"f7ee8bd\"'
	emake PREFIX="/usr" JANET_BUILD="${janet_build}"
	emake PREFIX="/usr" build/janet.pc JANET_BUILD="${janet_build}"
	emake PREFIX="/usr" docs JANET_BUILD="${janet_build}"
}

src_install() {
	dobin "build/janet"
	dobin "auxbin/jpm"

	doheader "src/include/janet.h"
	doheader "src/conf/janetconf.h"

	dolib.so "build/libjanet.so"
	dosym libjanet.so /usr/$(get_libdir)/libjanet.so.0

	if use static-libs; then
		dolib.a "build/libjanet.a"
	fi
	doman "janet.1"
	doman "jpm.1"

	insinto /usr/$(get_libdir)/pkgconfig/
	doins "build/janet.pc"
	dodoc -r examples
	dodoc "build/doc.html"
}
