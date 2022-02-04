# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=JESSE
DIST_VERSION=0.55
inherit perl-module

DESCRIPTION="A return-value object that lets you treat it as as a boolean, array or object"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc sparc x86"

RDEPEND="dev-perl/Devel-StackTrace"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.55-no-dot-inc.patch"
)
