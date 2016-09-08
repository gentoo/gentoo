# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

MY_PN=Nim
MY_P=${MY_PN}-${PV}

DESCRIPTION="compiled, garbage-collected systems programming language"
HOMEPAGE="http://nim-lang.org/"
SRC_URI="http://nim-lang.org/download/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +readline test"

DEPEND="
	readline? ( sys-libs/readline:0= )
"
RDEPEND="${DEPEND}"

nim_use_enable() {
	[[ -z $2 ]] && die "usage: nim_use_enable <USE flag> <compiler flag>"
	use $1 && echo "-d:$2"
}

src_compile() {
	./build.sh || die "build.sh failed"

	./bin/nim c koch || die "csources nim failed"
	./koch boot -d:release $(nim_use_enable readline useGnuReadline) || die "koch boot failed"

	if use doc; then
		PATH="./bin:$PATH" ./koch web || die "koch web failed"
	fi
}

src_test() {
	PATH="./bin:$PATH" ./koch test || die "test suite failed"
}

src_install() {
	./koch install "${D}/usr" || die "koch install failed"
	rm -r "${D}/usr/nim/doc"

	dodir /usr/bin
	dosym ../nim/bin/nim /usr/bin/nim

	if use doc; then
		insinto /usr/share/doc/${PF}
		dodoc doc/*.html
	fi
}
