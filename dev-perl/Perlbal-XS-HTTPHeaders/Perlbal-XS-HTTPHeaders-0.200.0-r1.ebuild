# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DORMANDO
MODULE_VERSION=0.20
inherit perl-module

DESCRIPTION="XS acceleration for Perlbal header processing"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-perl/Perlbal"
DEPEND="${RDEPEND}"
