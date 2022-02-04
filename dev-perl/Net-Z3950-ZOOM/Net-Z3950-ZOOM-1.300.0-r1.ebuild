# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIRK
DIST_VERSION=1.30
inherit perl-module

DESCRIPTION="Perl extension for invoking the ZOOM-C API"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/yaz-4.0.0:=
	>=dev-perl/MARC-Record-1.380.0
"
DEPEND="${RDEPEND}
"
BDEPEND="${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-1.28-network-tests.patch" )
