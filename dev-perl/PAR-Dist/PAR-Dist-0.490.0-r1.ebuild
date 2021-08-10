# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=RSCHUPP
MODULE_VERSION=0.49
inherit perl-module

DESCRIPTION="Create and manipulate PAR distributions"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE=""

DEPEND="
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	|| ( dev-perl/YAML-Syck dev-perl/YAML )
	dev-perl/Archive-Zip"
	# || ( YAML::Syck YAML YAML-Tiny YAML-XS Parse-CPAN-Meta )
RDEPEND="${DEPEND}"

SRC_TEST="do"
