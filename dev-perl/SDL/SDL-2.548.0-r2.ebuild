# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=FROGGS
DIST_VERSION=2.548
inherit perl-module

DESCRIPTION="Simple DirectMedia Layer (SDL) bindings for perl"
HOMEPAGE="http://sdl.perl.org/ https://search.cpan.org/dist/SDL/ https://github.com/PerlGameDev/SDL"

LICENSE="GPL-2 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

RDEPEND="
	>=dev-perl/Alien-SDL-1.446
	dev-perl/Capture-Tiny
	>=virtual/perl-CPAN-1.920.0
	>=virtual/perl-ExtUtils-CBuilder-0.260.301
	>=dev-perl/File-ShareDir-1.0.0
	>=dev-perl/Module-Build-0.400.0
	media-libs/libjpeg-turbo
	virtual/perl-Scalar-List-Utils
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
	virtual/opengl
"
BDEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Most-0.210.0
	)
"

mydoc='CHANGELOG README TODO'

PATCHES=(
	"${FILESDIR}"/${PN}-2.546-pointer.patch
	"${FILESDIR}"/${PN}-2.546-implicit-func-decl.patch
)
