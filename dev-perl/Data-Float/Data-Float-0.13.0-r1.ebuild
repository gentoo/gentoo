# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.013
inherit perl-module

DESCRIPTION="Details of the floating point data type"

SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"

PERL_RM_FILES=( "t/pod_syn.t" "t/pod_cvg.t" )
