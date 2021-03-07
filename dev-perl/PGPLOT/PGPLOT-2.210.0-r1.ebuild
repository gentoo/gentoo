# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KGB
DIST_VERSION=2.21
inherit perl-module

DESCRIPTION="allow subroutines in the PGPLOT graphics library to be called from Perl"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sci-libs/pgplot
	>=dev-perl/ExtUtils-F77-1.13"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.21-no-dot-inc.patch"
	"${FILESDIR}/${PN}-2.21-null-render.patch"
)
