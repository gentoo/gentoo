# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=FROGGS
DIST_VERSION=1.446
inherit perl-module toolchain-funcs

DESCRIPTION="building, finding and using SDL binaries"

SLOT="0"
KEYWORDS="amd64 ~hppa x86"

# File::Fetch, File::Find, Test::More -> dev-lang/perl
RDEPEND="
	dev-perl/Archive-Extract
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
	virtual/perl-File-Temp
"
DEPEND="
	media-libs/libsdl
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
"

PERL_RM_FILES=(
	t/release-pod-{syntax,coverage}.t
)
PATCHES=(
	"${FILESDIR}"/${PN}-1.444.0-fix-build-option.patch
	"${FILESDIR}"/${PN}-1.444.0-no-sysclean.patch
)
src_prepare() {
	tc-export CC
	perl-module_src_prepare
}

myconf='--with-sdl-config'
