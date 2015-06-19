# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/padre/padre-0.980.0-r1.ebuild,v 1.1 2014/08/29 19:12:48 axs Exp $

EAPI=5

MY_PN=Padre
MODULE_AUTHOR=PLAVEN
MODULE_VERSION=0.98
inherit perl-module

DESCRIPTION="Perl Application Development and Refactoring Environment"
HOMEPAGE="http://padre.perlide.org/"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Test Deps
TDEPEND="
	>=dev-perl/Test-MockObject-1.09
	>=dev-perl/Test-Script-1.07
	>=dev-perl/Test-Exception-0.27
	>=dev-perl/Test-NoWarnings-0.084
	>=virtual/perl-Test-Simple-0.88
	>=dev-perl/Test-Warn-0.240.0
"

# Depend on perl-5.10.1 but it only needs
# a modern EU::MM
#	>=virtual/perl-Pod-Perldoc-3.15
RDEPEND="
	>=dev-lang/perl-5.10.1
	>=dev-perl/Algorithm-Diff-1.190.0
	>=dev-perl/Capture-Tiny-0.06
	>=dev-perl/Class-Adapter-1.05
	>=dev-perl/Class-Inspector-1.22
	>=dev-perl/Class-XSAccessor-1.130.0
	>=dev-perl/DBD-SQLite-1.350.0
	>=dev-perl/DBI-1.58
	>=dev-perl/Devel-Dumpvar-0.04
	>=dev-perl/Debug-Client-0.200.0
	>=dev-perl/Devel-Refactor-0.05
	>=dev-perl/File-Copy-Recursive-0.37
	>=dev-perl/File-Find-Rule-0.30
	>=dev-perl/File-HomeDir-0.91
	>=virtual/perl-File-Path-2.08
	>=dev-perl/File-Remove-1.40
	>=dev-perl/File-ShareDir-1.00
	>=virtual/perl-File-Spec-3.27.01
	>=virtual/perl-File-Temp-0.20
	>=dev-perl/File-Which-1.08
	dev-perl/File-pushd
	virtual/perl-Getopt-Long
	>=dev-perl/HTML-Parser-3.58
	>=dev-perl/IO-stringy-2.110
	virtual/perl-IO
	>=dev-perl/IO-String-1.08
	>=dev-perl/IPC-Run-0.83
	>=dev-perl/JSON-XS-2.2.9
	>=virtual/perl-Scalar-List-Utils-1.18
	>=dev-perl/libwww-perl-5.815
	>=dev-perl/List-MoreUtils-0.22
	>=dev-perl/Locale-Msgfmt-0.15
	>=dev-perl/Module-Manifest-0.07
	>=dev-perl/ORLite-1.960.0
	>=dev-perl/ORLite-Migrate-1.100.0
	>=dev-perl/PAR-0.989
	>=dev-perl/Params-Util-0.33
	>=dev-perl/Parse-ErrorString-Perl-0.14
	>=dev-perl/Parse-ExuberantCTags-1.00
	>=dev-perl/Pod-Abstract-0.16
	>=dev-perl/Pod-POM-0.17
	>=virtual/perl-Pod-Simple-3.07
	>=dev-perl/PPI-1.205
	>=dev-perl/PPIx-EditorTools-0.130.0
	>=dev-perl/PPIx-Regexp-0.011
	dev-perl/Probe-Perl
	>=dev-perl/Sort-Versions-1.500.0
	>=virtual/perl-Storable-2.16
	>=dev-perl/Template-Tiny-0.11
	>=virtual/perl-Text-Balanced-0.80
	>=dev-perl/Text-Diff-1.410.0
	>=dev-perl/Text-FindIndent-0.10
	>=dev-perl/Text-Patch-1.800.0
	>=virtual/perl-threads-1.71
	>=virtual/perl-threads-shared-1.33
	>=virtual/perl-Time-HiRes-1.97.18
	>=dev-perl/URI-0
	>=dev-perl/wxperl-0.990.100
	>=dev-perl/Wx-Perl-ProcessStream-0.28
	>=dev-perl/Wx-Scintilla-0.340.0
	>=dev-perl/YAML-Tiny-1.32
	>=virtual/perl-version-0.79
"
DEPEND="${RDEPEND}"
#	test? (
#		${TDEPEND}
#	)
#"

#SRC_TEST=do

src_configure() {
	unset DISPLAY
	perl-module_src_configure
}
