# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/smp_utils/smp_utils-0.98.ebuild,v 1.1 2014/09/22 08:16:14 polynomial-c Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="Utilities for SAS management protocol (SMP)"
HOMEPAGE="http://sg.danny.cz/sg/smp_utils.html"
SRC_URI="http://sg.danny.cz/sg/p/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs"

DOCS=( AUTHORS ChangeLog COVERAGE CREDITS README )

AUTOTOOLS_IN_SOURCE_BUILD=1
