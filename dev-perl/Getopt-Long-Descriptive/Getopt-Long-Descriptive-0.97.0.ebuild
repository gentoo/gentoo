# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=0.097
inherit perl-module

DESCRIPTION="Getopt::Long with usage text"

SLOT="0"
KEYWORDS="amd64 arm ppc x86 ~ppc-aix ~ppc-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/Params-Validate-0.970.0
	dev-perl/IO-stringy
	dev-perl/Sub-Exporter
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Warnings )"

SRC_TEST=do
