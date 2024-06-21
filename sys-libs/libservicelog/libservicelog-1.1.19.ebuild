# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Provides a library for logging service-related events"
SRC_URI="https://github.com/power-ras/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/power-ras/libservicelog"

SLOT="0"
LICENSE="GPL-2+"
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
src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	local DOCS=( ChangeLog README )
	default
	find "${D}" -name '*.la' -delete || die
}
