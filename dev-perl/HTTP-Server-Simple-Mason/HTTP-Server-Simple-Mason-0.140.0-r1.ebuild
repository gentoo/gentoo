# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JESSE
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="An abstract baseclass for a standalone mason server"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="
	dev-perl/Hook-LexWrap
	dev-perl/URI
	dev-perl/libwww-perl
	>=dev-perl/HTML-Mason-1.250.0
	>=dev-perl/HTTP-Server-Simple-0.40.0
"
DEPEND="${RDEPEND}"

# Parallel failures,
# https://bugs.gentoo.org/623112
DIST_TEST="do"
src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
src_test() {
	perl_rm_files t/02pod.t t/03podcoverage.t
	perl-module_src_test
}
