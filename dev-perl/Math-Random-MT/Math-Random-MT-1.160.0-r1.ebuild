# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Math-Random-MT/Math-Random-MT-1.160.0-r1.ebuild,v 1.1 2014/08/26 14:52:02 axs Exp $

EAPI=5

MODULE_AUTHOR=FANGLY
MODULE_VERSION=1.16
inherit perl-module

DESCRIPTION="The Mersenne Twister PRNG"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? (
		dev-perl/Test-Number-Delta
	)
"

SRC_TEST=do
