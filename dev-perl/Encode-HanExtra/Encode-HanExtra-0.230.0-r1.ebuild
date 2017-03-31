# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=AUDREYT
MODULE_VERSION=0.23
inherit perl-module

DESCRIPTION="Extra sets of Chinese encodings"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="virtual/perl-Encode"
RDEPEND="${DEPEND}"

#SRC_TEST="do"
