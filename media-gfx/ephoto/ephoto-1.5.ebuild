# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Enlightenment image viewer written with EFL"
HOMEPAGE="https://www.enlightenment.org/about-ephoto"
SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P}.tar.xz -> ${P}-1.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="dev-libs/efl[eet,X]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_configure() {
	local myconf=(
		$(use_enable nls)
	)

	econf "${myconf[@]}"
}
