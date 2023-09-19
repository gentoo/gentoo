# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CEESHEK
DIST_VERSION=1.00
inherit perl-module

DESCRIPTION="Easy external redirects in CGI::Application"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	virtual/perl-Exporter
"
DEPEND="dev-perl/Module-Build"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/CGI-Application
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	t/98_pod.t
	t/99_pod_coverage.t
)
