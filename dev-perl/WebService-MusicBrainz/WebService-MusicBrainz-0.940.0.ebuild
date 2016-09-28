# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=BFAIST
DIST_VERSION=0.94
inherit perl-module

DESCRIPTION="Web service API to MusicBrainz database"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/Class-Accessor-0.300.0
	dev-perl/libwww-perl
	>=dev-perl/URI-1.350.0
	>=dev-perl/XML-LibXML-1.630.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
"

DIST_TEST=skip
# network tests, can be handled better
