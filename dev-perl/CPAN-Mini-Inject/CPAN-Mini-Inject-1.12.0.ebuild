# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BRIANDFOY
DIST_VERSION=1.012
inherit perl-module

DESCRIPTION="Inject modules into a CPAN::Mini mirror"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/CPAN-Checksums-2.130.0
	>=dev-perl/CPAN-Mini-0.320.0
	>=dev-perl/Dist-Metadata-0.921.0
	>=virtual/perl-File-Path-2.70.0
	dev-perl/File-Slurp
	>=virtual/perl-File-Spec-2.70.0
	dev-perl/libwww-perl
	dev-perl/YAML
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/HTTP-Daemon
	)
"

PERL_RM_FILES=( t/pod-coverage.t t/pod.t )
