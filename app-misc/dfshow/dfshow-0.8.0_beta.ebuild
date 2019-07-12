# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PV="${PV//_beta/-beta}"

DESCRIPTION="DF-SHOW is a Unix-like rewrite of some of the applications from DF-EDIT"
HOMEPAGE="https://github.com/roberthawdon/dfshow"
SRC_URI="https://github.com/roberthawdon/dfshow/archive/v${MY_PV}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/ncurses"

src_prepare() {
	default
	eautoreconf
	eautomake --add-missing
}
