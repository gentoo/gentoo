# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${PN}-v${PV}"

DESCRIPTION="A general-purpose fuzzer"
HOMEPAGE="https://gitlab.com/akihe/radamsa"
SRC_URI="
	https://gitlab.com/akihe/${PN}/-/archive/v${PV}/${MY_P}.tar.bz2
	https://gitlab.com/akihe/${PN}/uploads/d774a42f7893012d0a56c490a75ae12b/${P}.c.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# needs an owl-lisp
RESTRICT=test

PATCHES=(
	"${FILESDIR}"/${PN}-0.7_prebuilt-c.patch
)

S="${WORKDIR}"/${MY_P}

src_prepare() {
	default

	cp "${WORKDIR}"/${P}.c "${S}"/${PN}.c || die
}

src_compile() {
	emake bin/radamsa CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin bin/radamsa
	# avoid man compression by build system
	doman doc/radamsa.1

	einstalldocs
}
