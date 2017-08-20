# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PERIGRIN
DIST_VERSION=0.4
inherit perl-module

DESCRIPTION="DOCTYPE based XML output"

LICENSE="|| ( Artistic GPL-1+ BSD )"
SLOT="0"
KEYWORDS="amd64 hppa ia64 sparc x86"
IUSE=""

RDEPEND="dev-perl/XML-Parser"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i '/^auto_set_repository/d' Makefile.PL || die

	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"

	perl-module_src_prepare
}
