# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A dynamic Lisp dialect and bytecode vm"
HOMEPAGE="https://janet-lang.org"
SRC_URI="https://github.com/janet-lang/${PN}/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	emake PREFIX="/usr" JANET_BUILD='\"5171dfd\"'
	emake PREFIX="/usr" build/janet.pc JANET_BUILD='"\5171dfd\"'
	emake PREFIX="/usr" docs JANET_BUILD='\"5171dfd\"'
}

src_install() {
	dobin "build/janet"
	dobin "auxbin/jpm"
	doheader "src/include/janet.h"
	doheader "src/conf/janetconf.h"
	dolib.so "build/libjanet.so"
	doman "janet.1"
	doman "jpm.1"
	insinto /usr/lib/pkgconfig
	doins "build/janet.pc"
	insinto /usr/share/janet
	doins -r examples
	doins "build/doc.html"
}
