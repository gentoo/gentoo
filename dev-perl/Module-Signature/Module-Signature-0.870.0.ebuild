# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AUDREYT
DIST_VERSION=0.87
inherit perl-module

DESCRIPTION="Module signature file manipulation"

LICENSE="CC0-1.0 || ( Artistic GPL-2+ )"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/Crypt-OpenPGP
	app-crypt/gnupg
	virtual/perl-File-Temp
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		dev-perl/IPC-Run
	)
"
