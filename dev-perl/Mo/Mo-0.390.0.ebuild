# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mo/Mo-0.390.0.ebuild,v 1.1 2015/06/26 09:17:07 monsieurp Exp $
EAPI=5

MODULE_AUTHOR=INGY
MODULE_VERSION=0.39
inherit perl-module

DESCRIPTION="Perl Micro Object framework"
HOMEPAGE="https://metacpan.org/pod/distribution/Mo/lib/Mo.pod"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}"

SRC_TEST="do"
