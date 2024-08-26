# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit autotools guile

DESCRIPTION="Guile application configuration parsing library"
HOMEPAGE="https://gitlab.com/a-sassmannshausen/guile-config/"
SRC_URI="https://gitlab.com/a-sassmannshausen/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="${GUILE_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	guile_src_prepare
	eautoreconf
}
