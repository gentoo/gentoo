# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=AUTRIJUS
MODULE_VERSION=0.07
inherit perl-module

DESCRIPTION="Encode.pm emulation layer"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE=""
LICENSE="Artistic"

RDEPEND="dev-perl/Text-Iconv"
DEPEND="${RDEPEND}"

#SRC_TEST="do"
