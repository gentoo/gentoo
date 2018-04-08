# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=1.7
inherit perl-module

DESCRIPTION="Provide utility methods for factory classes"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ia64 ppc ~ppc64 sparc x86 ~ppc-aix ~x86-fbsd ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.28"

src_test() {
	perl_rm_files t/pod{,-coverage}.t
	perl-module_src_test
}
