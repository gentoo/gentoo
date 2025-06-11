# Copyright 1999-2025 Gentoo Authors
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
S="${WORKDIR}"/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-scheme/owl-lisp )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7_prebuilt-c.patch
	"${FILESDIR}"/${PN}-0.7-no-which.patch
)

src_prepare() {
	default

	cp "${WORKDIR}"/${P}.c "${S}"/${PN}.c || die
}

src_compile() {
	emake -Onone bin/radamsa CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_test() {
	ln -s "${BROOT}"/usr/bin/ol bin/ol || die
	emake -Onone test
}

src_install() {
	dobin bin/radamsa
	# avoid man compression by build system
	doman doc/radamsa.1

	einstalldocs
}
