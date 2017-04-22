# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KENTNL
DIST_VERSION=6.06
inherit perl-module

DESCRIPTION="Report errors from perspective of caller of a clan of modules"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Exception )"

src_test() {
	perl_rm_files t/01pod.t t/03yaml.t
	perl-module_src_test
}
