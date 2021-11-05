# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHERWIN
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Check password strength and generate password using passwdqc"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/List-MoreUtils
	dev-perl/Moose
	dev-perl/namespace-autoclean
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	dev-perl/Devel-CheckOS
	test? (
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=(
	t/pod.t
)

src_prepare() {
	einfo "Stripping Devel-CheckOS from inc/"
	rm -rf "${S}/inc/Devel/CheckOS.pm" \
			"${S}/inc/Devel/AssertOS.pm" \
			"${S}/inc/Devel/AssertOS" ||
			die "Can't remove bundled Devel-CheckOS bits"
	sed -i -e '/^inc\/Devel\/\(Check\|Assert\)OS/d' MANIFEST ||
		die "Can't remove Devel-CheckOS bits from MANIFEST"
	perl-module_src_prepare
}
