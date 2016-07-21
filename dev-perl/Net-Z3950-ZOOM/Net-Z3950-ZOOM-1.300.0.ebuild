# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MIRK
DIST_VERSION=1.30
inherit perl-module

DESCRIPTION="Perl extension for invoking the ZOOM-C API"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-perl/MARC-Record
	>=dev-libs/yaz-4
"
DEPEND="${RDEPEND}"
