# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Provides utilities for logging service-related events"
HOMEPAGE="http://linux-diag.sourceforge.net/servicelog/"
SRC_URI="https://github.com/power-ras/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~ppc ~ppc64"

DEPEND="
	sys-libs/libservicelog
"
RDEPEND="
	${DEPEND}
	virtual/logger
"
DOCS="ChangeLog"

src_prepare() {
	default
	eautoreconf
}
