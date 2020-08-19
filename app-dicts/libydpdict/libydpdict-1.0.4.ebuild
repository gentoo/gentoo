# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Library for handling the Collins Dictionary database"
HOMEPAGE="https://github.com/wojtekka/libydpdict"
SRC_URI="https://github.com/wojtekka/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dodoc AUTHORS
}
