# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JMCNAMARA
DIST_VERSION=0.66
inherit perl-module

DESCRIPTION="Read information from an Excel file"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="cjk unicode"

# Digest::Perl::MD5 cannot be replaced by Digest::MD5, as this module actually
# interacts with the internal state of Digest::Perl::MD5.
RDEPEND="
	>=dev-perl/OLE-StorageLite-0.19
	dev-perl/IO-stringy
	dev-perl/Text-CSV_XS
	dev-perl/Crypt-RC4
	dev-perl/Digest-Perl-MD5
	unicode? ( dev-perl/Unicode-Map )
	cjk? ( dev-perl/Jcode )
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Unicode-Map
		dev-perl/Spreadsheet-WriteExcel
		dev-perl/Jcode
	)
"

src_test() {
	perl_rm_files t/90_pod.t t/91_minimumversion.t t/92_meta.t
	perl-module_src_test
}
