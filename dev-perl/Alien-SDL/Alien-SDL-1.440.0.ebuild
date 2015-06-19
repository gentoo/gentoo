# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Alien-SDL/Alien-SDL-1.440.0.ebuild,v 1.8 2015/06/13 19:22:44 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=FROGGS
MODULE_VERSION=1.440
inherit perl-module toolchain-funcs

DESCRIPTION="building, finding and using SDL binaries"

SLOT="0"
KEYWORDS="amd64 hppa x86"

# File::Fetch, File::Find, Test::More -> dev-lang/perl
RDEPEND="dev-perl/Archive-Extract
	dev-perl/Archive-Zip
	dev-perl/Capture-Tiny
	dev-perl/File-ShareDir
	dev-perl/File-Which
	dev-perl/Text-Patch
	media-libs/libsdl
	virtual/perl-Archive-Tar
	virtual/perl-Digest-SHA
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/Module-Build
	virtual/perl-File-Spec
	virtual/perl-File-Temp"
DEPEND=${RDEPEND}

SRC_TEST=do
myconf='--with-sdl-config'

src_prepare() {
	tc-export CC
	perl-module_src_prepare
}
