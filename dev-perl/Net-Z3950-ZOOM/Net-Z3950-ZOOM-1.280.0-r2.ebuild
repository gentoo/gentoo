# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MIRK
DIST_VERSION=1.28
inherit perl-module

DESCRIPTION="Perl extension for invoking the ZOOM-C API"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-libs/yaz-2.1.50
	dev-perl/MARC-Record
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/${PN}-1.28-network-tests.patch" )
