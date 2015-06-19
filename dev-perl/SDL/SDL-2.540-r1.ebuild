# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SDL/SDL-2.540-r1.ebuild,v 1.3 2015/06/13 22:41:26 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=JTPALMER
inherit perl-module

DESCRIPTION="Simple DirectMedia Layer (SDL) bindings for perl"
HOMEPAGE="http://sdl.perl.org/ http://search.cpan.org/dist/SDL/ http://github.com/PerlGameDev/SDL"

LICENSE="GPL-2 OFL-1.1"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE=""

RDEPEND=">=dev-perl/Alien-SDL-1.434
	dev-perl/Capture-Tiny
	dev-perl/File-ShareDir
	dev-perl/Test-Most
	dev-perl/Tie-Simple
	media-libs/libpng:0
	media-libs/libsdl
	media-libs/sdl-gfx
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-pango
	media-libs/sdl-ttf
	media-libs/smpeg
	media-libs/tiff:0
	virtual/glu
	virtual/jpeg:0
	virtual/opengl
	virtual/perl-ExtUtils-CBuilder
	>=dev-perl/Module-Build-0.400.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-Test-Simple"
DEPEND=${RDEPEND}

SRC_TEST=do
mydoc='CHANGELOG README TODO'
