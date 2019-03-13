# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=AUDREYT
DIST_VERSION=0.81
inherit perl-module

DESCRIPTION="Module signature file manipulation"

LICENSE="CC0-1.0 || ( Artistic GPL-2+ )"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-solaris"
IUSE="test"

RDEPEND="
	dev-perl/Crypt-OpenPGP
	app-crypt/gnupg
	virtual/perl-File-Temp
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/IPC-Run
	)
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install /use lib q[.]; use inc::Module::Install /' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
