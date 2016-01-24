# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="ADAMK"
MODULE_VERSION=1.13

inherit perl-module

DESCRIPTION="Common rules for searching for Perl things"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=dev-perl/File-Find-Rule-0.32
	dev-perl/Params-Util
"
