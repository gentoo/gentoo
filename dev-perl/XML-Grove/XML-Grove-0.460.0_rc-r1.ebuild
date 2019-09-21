# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=KMACLEOD
DIST_VERSION=0.46alpha
inherit perl-module

DESCRIPTION="A Perl module providing a simple API to parsed XML instances"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/XML-Parser-2.190.0
	dev-perl/libxml-perl
"
DEPEND="${RDEPEND}"
PATCHES=(
	"${FILESDIR}/${PN}-0.46-badversion.patch"
	"${FILESDIR}/${PN}-0.46-utf8tests.patch"
)
