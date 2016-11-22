# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=JHOBLITT
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="Parses ISO8601 formats"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="test"

RDEPEND="dev-perl/DateTime
	dev-perl/DateTime-Format-Builder"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/File-Find-Rule
	)"

SRC_TEST=do

src_test() {
	perl_rm_files t/00_distribution.t t/99_pod.t
	perl-module_src_test
}
