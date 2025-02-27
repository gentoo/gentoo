# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BAREFOOT
DIST_VERSION=0.13
inherit perl-module

DESCRIPTION="Module used to generate random data"

SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
"
BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		virtual/perl-File-Temp
		dev-perl/Test-MockTime
		>=virtual/perl-Test-Simple-0.880.0
	)
"
PERL_RM_FILES=(
	"t/author-pod-syntax.t"
	"t/z0_pod.t"
	"t/z1_pod-coverage.t"
)

src_test() {
	ewarn "Comprehensive testing of this package may involve manual steps."
	ewarn "For details, see:"
	ewarn " https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}#Testing"
	perl-module_src_test
}

pkg_postinst() {
	ewarn "This package may require additional dependencies for some optional features."
	ewarn "For details, see:"
	ewarn " https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}#Optional_Features"
}
