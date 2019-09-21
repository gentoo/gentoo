# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Provides utilities for logging service-related events"
SRC_URI="mirror://sourceforge/linux-diag/${P}.tar.gz"
HOMEPAGE="http://linux-diag.sourceforge.net/servicelog/"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="ppc ppc64"

DEPEND="
	sys-libs/libservicelog
"
RDEPEND="
	${DEPEND}
	virtual/logger
"
DOCS="ChangeLog"
