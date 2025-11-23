# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module toolchain-funcs

COMMIT="b94e0d36669c4cc086856adf57bc67ced8f1aaf0"
DESCRIPTION="A license identification tool for source code"
HOMEPAGE="http://ninka.turingmachine.org/"
SRC_URI="https://github.com/dmgerman/${PN}/archive/${COMMIT}.tar.gz -> ${PN}-${COMMIT}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+ myspell-en_CA-KevinAtkinson public-domain Princeton Ispell"
SLOT="0"
KEYWORDS="~amd64"
IUSE="sqlite test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/IO-CaptureOutput
	dev-perl/Spreadsheet-WriteExcel
	virtual/perl-File-Temp
	sqlite? (
		dev-perl/DBD-SQLite
		dev-perl/DBI
	)"

BDEPEND="virtual/perl-ExtUtils-MakeMaker
	test? (
		${RDEPEND}
		dev-perl/Test-Pod
		dev-perl/Test-Strict
		virtual/perl-Test-Simple
	)"

PATCHES=( "${FILESDIR}"/${PN}-2.0_pre1_p20170402-makefile.patch )

src_compile() {
	perl-module_src_compile
	emake -C comments CXX="$(tc-getCXX)"
}

src_install() {
	perl-module_src_install
	use sqlite || rm "${ED}"/usr/bin/ninka-sqlite || die
	dobin comments/comments
	doman comments/comments.1
	dodoc BUGS.org
}
