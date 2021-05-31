# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MICHIELB
DIST_VERSION=0.29
inherit perl-module

DESCRIPTION="Determine file type"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	>=dev-perl/File-BaseDir-0.30.0
	>=dev-perl/File-DesktopEntry-0.40.0
	x11-misc/shared-mime-info
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	t/06_pod_ok.t
	t/07_pod_cover.t
	t/08_changes.t
	t/09_no404s.t
)
