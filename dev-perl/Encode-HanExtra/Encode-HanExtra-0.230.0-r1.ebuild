# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Encode-HanExtra/Encode-HanExtra-0.230.0-r1.ebuild,v 1.1 2014/08/26 16:10:45 axs Exp $

EAPI=5

MODULE_AUTHOR=AUDREYT
MODULE_VERSION=0.23
inherit perl-module

DESCRIPTION="Extra sets of Chinese encodings"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/perl-Encode"
RDEPEND="${DEPEND}"

#SRC_TEST="do"
