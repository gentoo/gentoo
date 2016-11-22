# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PEVANS
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="Color space conversions and named lookups"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Module-Pluggable
	dev-perl/List-UtilsBy
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		virtual/perl-Test-Simple
	)
"

SRC_TEST=do

src_test() {
	perl_rm_files t/99pod.t
	perl-module_src_test
}
