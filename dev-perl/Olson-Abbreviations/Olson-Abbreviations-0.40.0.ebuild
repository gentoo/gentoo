# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ECARROLL
MODULE_VERSION=0.04
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
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do

# MI's fault
src_configure() {
	use test && perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_configure
}
