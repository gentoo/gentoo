# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="compiled, garbage-collected systems programming language"
HOMEPAGE="https://nim-lang.org/"
SRC_URI="https://nim-lang.org/download/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
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
	rm -r "${D}/usr/nim/doc" || die "failed to remove 'doc'"

	dodir /usr/bin
	dosym ../nim/bin/nim /usr/bin/nim

	if use doc; then
		insinto /usr/share/doc/${PF}
		dodoc doc/*.html
	fi
}
