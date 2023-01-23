# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A library of routines for managing a database"
HOMEPAGE="https://dbmx.net/tkrzw/"
SRC_URI="https://dbmx.net/tkrzw/pkg/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

RESTRICT="!test? ( test )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	myconf=(
		$(use_enable test check)
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	use doc && dodoc -r doc/.
}
