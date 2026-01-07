# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DFARALDO
DIST_VERSION=1.07
inherit perl-module

DESCRIPTION="Import environment variable changes from external commands or shell scripts"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	>=dev-perl/Class-MethodMaker-2
"
BDEPEND="${RDEPEND}
"

PATCHES=( "${FILESDIR}/${P}-perl520.patch" )

# https://rt.cpan.org/Public/Bug/Display.html?id=105478
DIST_TEST=nope
