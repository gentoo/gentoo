# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module toolchain-funcs

DESCRIPTION="A license identification tool for source code"
HOMEPAGE="http://ninka.turingmachine.org/"
# snapshot of https://github.com/dmgerman/ninka
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

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

DEPEND="virtual/perl-ExtUtils-MakeMaker
	test? (
		${RDEPEND}
		dev-perl/Test-Pod
		dev-perl/Test-Strict
		virtual/perl-Test-Simple
	)"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${P}-braces.patch
	"${FILESDIR}"/${P}-makefile.patch
)

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
