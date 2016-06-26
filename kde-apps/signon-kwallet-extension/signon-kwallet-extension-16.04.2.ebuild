# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="KWallet extension for signond"
HOMEPAGE="https://01.org/gsso/"
KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1"

DEPEND="
	$(add_frameworks_dep kwallet)
	net-libs/signond
"
RDEPEND="${DEPEND}"
