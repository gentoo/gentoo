# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Provides a library for logging service-related events"
SRC_URI="https://downloads.sourceforge.net/linux-diag/${P}.tar.gz"
HOMEPAGE="http://linux-diag.sourceforge.net/servicelog/"

SLOT="0"
LICENSE="LGPL-2.1+"
KEYWORDS="ppc ppc64"
IUSE="static-libs"
RESTRICT="test" # bug 801235

DEPEND="
	dev-db/sqlite:=
	sys-libs/librtas
"
RDEPEND="
	${DEPEND}
	virtual/logger
"

DOCS=( ChangeLog )

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
