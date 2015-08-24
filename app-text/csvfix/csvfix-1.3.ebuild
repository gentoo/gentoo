# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs versionator

MY_PV="$(delete_all_version_separators)"
DESCRIPTION="A stream editor for manipulating CSV files"
HOMEPAGE="https://code.google.com/p/csvfix/"
SRC_URI="https://dev.gentoo.org/~radhermit/dist/${P}.tar.bz2
	doc? ( https://csvfix.googlecode.com/files/CSVfix_man_html_${MY_PV}0.zip )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-libs/expat"
DEPEND="${RDEPEND}
	doc? ( app-arch/unzip )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-make.patch
	epatch "${FILESDIR}"/${PN}-1.10a-tests.patch

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
	use doc && dohtml -r "${WORKDIR}"/${PN}${MY_PV}/*
}
