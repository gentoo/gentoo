# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_NAME=Padre
DIST_AUTHOR=PLAVEN
DIST_VERSION=1.00
inherit perl-module

DESCRIPTION="Perl Application Development and Refactoring Environment"
HOMEPAGE="https://padre.perlide.org/"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

# Test Deps
TESTDEPEND="
	>=dev-perl/Test-MockObject-1.90.0
	>=dev-perl/Test-Script-1.70.0
	>=dev-perl/Test-Exception-0.270.0
	>=dev-perl/Test-NoWarnings-0.84.0
	>=virtual/perl-Test-Simple-0.880.0
	>=dev-perl/Test-Warn-0.240.0
"

RDEPEND="
	|| ( >=dev-lang/perl-5.38.2-r3[perl_features_ithreads] <dev-lang/perl-5.38.2-r3[ithreads] )
	>=dev-lang/perl-5.10.1
	>=dev-perl/Algorithm-Diff-1.190.0
	>=dev-perl/Capture-Tiny-0.60.0
	>=dev-perl/Class-Adapter-1.50.0
	>=dev-perl/Class-Inspector-1.220.0
	>=dev-perl/Class-XSAccessor-1.130.0
	>=dev-perl/DBD-SQLite-1.350.0
	>=dev-perl/DBI-1.580.0
	>=dev-perl/Devel-Dumpvar-0.40.0
	>=dev-perl/Debug-Client-0.200.0
	>=dev-perl/Devel-Refactor-0.50.0
	>=dev-perl/File-Copy-Recursive-0.370.0
	>=dev-perl/File-Find-Rule-0.300.0
	>=dev-perl/File-HomeDir-0.910.0
	>=virtual/perl-File-Path-2.80.0
	>=dev-perl/File-Remove-1.400.0
	>=dev-perl/File-ShareDir-1.0.0
	>=virtual/perl-File-Spec-3.27.1
	>=virtual/perl-File-Temp-0.200.0
	>=dev-perl/File-Which-1.80.0
	dev-perl/File-pushd
	virtual/perl-Getopt-Long
	>=dev-perl/HTML-Parser-3.580.0
	>=dev-perl/IO-stringy-2.110.0
	virtual/perl-IO
	>=dev-perl/IO-String-1.80.0
	>=dev-perl/IPC-Run-0.830.0
	>=dev-perl/JSON-XS-2.2.9
	>=virtual/perl-Scalar-List-Utils-1.180.0
	>=dev-perl/libwww-perl-5.815.0
	>=dev-perl/List-MoreUtils-0.220.0
	>=dev-perl/Locale-Msgfmt-0.150.0
	>=dev-perl/Module-Manifest-0.70.0
	>=dev-perl/ORLite-1.960.0
	>=dev-perl/ORLite-Migrate-1.100.0
	>=dev-perl/PAR-0.989.0
	>=dev-perl/Params-Util-0.330.0
	>=dev-perl/Parse-ErrorString-Perl-0.140.0
	>=dev-perl/Parse-ExuberantCTags-1.0.0
	>=dev-perl/Pod-Abstract-0.160.0
	>=dev-perl/Pod-POM-0.170.0
	>=virtual/perl-Pod-Simple-3.70.0
	>=dev-perl/PPI-1.205.0
	>=dev-perl/PPIx-EditorTools-0.130.0
	>=dev-perl/PPIx-Regexp-0.11.0
	dev-perl/Probe-Perl
	>=dev-perl/Sort-Versions-1.500.0
	>=virtual/perl-Storable-2.160.0
	>=dev-perl/Template-Tiny-0.110.0
	>=virtual/perl-Text-Balanced-0.800.0
	>=dev-perl/Text-Diff-1.410.0
	>=dev-perl/Text-FindIndent-0.100.0
	>=dev-perl/Text-Patch-1.800.0
	>=virtual/perl-threads-1.710.0
	>=virtual/perl-Time-HiRes-1.97.18
	dev-perl/URI
	>=dev-perl/Wx-0.990.100
	>=dev-perl/Wx-Perl-ProcessStream-0.280.0
	>=dev-perl/Wx-Scintilla-0.340.0
	>=dev-perl/YAML-Tiny-1.320.0
	>=virtual/perl-version-0.790.0
"
BDEPEND="${RDEPEND}
	test? (
		${TESTDEPEND}
	)
"

#DIST_TEST=skip

PATCHES=(
	"${FILESDIR}/${P}-DBD-Sqlite.patch"
	"${FILESDIR}/${P}-utf8.patch"
)

src_configure() {
	unset DISPLAY
	perl-module_src_configure
}

src_prepare() {
	sed -i -e 's/^use inc::Module::Install/use lib q[.];\nuse inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
