# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.006
inherit perl-module

DESCRIPTION="dynamic class mixing"
SLOT="0"
KEYWORDS="amd64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Params-Classify
	virtual/perl-Exporter
	virtual/perl-if
	virtual/perl-parent
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	t/pod_cvg.t
	t/pod_syn.t
)
