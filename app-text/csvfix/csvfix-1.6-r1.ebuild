# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edos2unix toolchain-funcs

DESCRIPTION="A stream editor for manipulating CSV files"
HOMEPAGE="https://github.com/jheusser/csvfix"
SRC_URI="https://github.com/jheusser/csvfix/archive/version-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/expat"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-version-${PV}"

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
	"${FILESDIR}/${PN}-1.10a-tests.patch"
	"${FILESDIR}/${P}-shuffle-test.patch"
)

src_prepare() {
	default
	edos2unix $(find csvfix/tests -type f)
	chmod +x ${PN}/tests/run{1,tests} || die
}

src_compile() {
	emake CC="$(tc-getCXX)" AR="$(tc-getAR)" lin
}

src_test() {
	cd ${PN}/tests && ./runtests || die "tests failed"
}

src_install() {
	dobin csvfix/bin/csvfix
	dodoc readme.txt
}
