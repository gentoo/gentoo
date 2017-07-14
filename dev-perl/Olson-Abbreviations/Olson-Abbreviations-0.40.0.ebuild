# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ECARROLL
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Globally unique timezones abbreviation handling"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Moose
	>=dev-perl/MooseX-ClassAttribute-0.250.0
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/List-MoreUtils
		virtual/perl-Test-Simple
	)
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
	use test && perl_rm_files t/pod.t t/pod-coverage.t
}
