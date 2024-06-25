# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.012

inherit perl-module

DESCRIPTION="Querying your filehandle's capabilities"

SLOT="0"
KEYWORDS="amd64 arm ~ppc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-XSLoader
"

BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.360.100
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.820.0
	)
"

PERL_RM_FILES=(
	t/release-pod-coverage.t
	t/release-pod-syntax.t
)
