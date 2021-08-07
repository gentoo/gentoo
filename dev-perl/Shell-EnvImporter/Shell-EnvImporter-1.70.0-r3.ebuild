# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DFARALDO
DIST_VERSION=1.07
inherit perl-module

DESCRIPTION="Import environment variable changes from external commands or shell scripts"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"

RDEPEND="
	>=dev-perl/Class-MethodMaker-2
"
BDEPEND="${RDEPEND}
"

PATCHES=( "${FILESDIR}/${P}-perl520.patch" )

# https://rt.cpan.org/Public/Bug/Display.html?id=105478
DIST_TEST=nope
