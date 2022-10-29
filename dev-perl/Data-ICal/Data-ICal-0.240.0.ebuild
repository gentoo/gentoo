# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BPS
DIST_VERSION=0.24
inherit perl-module

DESCRIPTION="Generates iCalendar (RFC 2445) calendar files"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Class-Accessor
	dev-perl/Class-ReturnValue
	virtual/perl-MIME-Base64
	dev-perl/Text-vFile-asData
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		dev-perl/Test-LongString
		dev-perl/Test-NoWarnings
		virtual/perl-Test-Simple
		dev-perl/Test-Warn
	)
"
PERL_RM_FILES=(
	"t/pod.t"
	"t/pod-coverage.t"
)
PATCHES=(
	"${FILESDIR}/${PN}-0.24-no-autoinstall.patch"
	"${FILESDIR}/${PN}-0.24-no-dot-inc.patch"
)
