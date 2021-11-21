# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AUDREYT
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Maketext from already interpolated strings"

SLOT="0"
LICENSE="CC0-1.0"
KEYWORDS="amd64 ~hppa ppc x86"

src_prepare() {
	sed -i -e 's/use inc::Module::Package/use lib q[.];\nuse inc::Module::Package/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
