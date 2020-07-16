# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs versionator vcs-snapshot eutils

MY_PV="$(delete_all_version_separators)"
DESCRIPTION="A stream editor for manipulating CSV files"
HOMEPAGE="https://neilb.bitbucket.org/csvfix/ https://bitbucket.org/neilb/csvfix/"
SRC_URI="https://bitbucket.org/neilb/csvfix/get/version-${PV}.tar.bz2 -> ${P}.tar.bz2
	doc? ( https://bitbucket.org/neilb/csvfix/downloads/csvfix_man_html_${MY_PV}0.zip )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-libs/expat"
DEPEND="${RDEPEND}
	doc? ( app-arch/unzip )"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${PN}-1.10a-tests.patch
	"${FILESDIR}"/${P}-shuffle-test.patch
)

src_prepare() {
	default
	edos2unix $(find csvfix/tests -type f)
}

src_compile() {
	emake CC="$(tc-getCXX)" AR="$(tc-getAR)" lin
}

src_test() {
	cd ${PN}/tests
	chmod +x run1 runtests
	./runtests || die "tests failed"
}

src_install() {
	dobin csvfix/bin/csvfix
	if use doc; then
		docinto html
		dodoc -r "${WORKDIR}"/${PN}${MY_PV}/*
	fi
}
