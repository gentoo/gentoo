# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RKITOVER
DIST_VERSION=0.26
inherit perl-module

DESCRIPTION="Compile .cgi scripts to a code reference like ModPerl::Registry"
SLOT="0"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-perl/File-pushd
	dev-perl/Sub-Name
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		dev-perl/CGI
		dev-perl/Capture-Tiny
		dev-perl/Filter
		dev-perl/Sub-Identify
		dev-perl/Test-NoWarnings
		dev-perl/Test-Requires
		virtual/perl-Test-Simple
		dev-perl/Try-Tiny
	)
"

PERL_RM_FILES=(
	"t/author-pod-syntax.t"
)
