# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RKITOVER
DIST_VERSION=0.24
inherit perl-module

DESCRIPTION="Compile .cgi scripts to a code reference like ModPerl::Registry"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/File-pushd
	dev-perl/Sub-Name
"
DEPEND="
	dev-perl/Module-Build-Tiny
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		dev-perl/CGI
		dev-perl/Capture-Tiny
		dev-perl/Sub-Identify
		dev-perl/Switch
		dev-perl/Test-NoWarnings
		dev-perl/Test-Requires
		virtual/perl-Test-Simple
		dev-perl/Try-Tiny
	)
"
PERL_RM_FILES=(
	"t/author-pod-syntax.t"
)
