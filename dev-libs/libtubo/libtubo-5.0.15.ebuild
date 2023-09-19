# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${PN}0-${PV}

DESCRIPTION="small and simple interprocess communication library"
HOMEPAGE="http://xffm.org/libtubo"
SRC_URI="mirror://sourceforge/xffm/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"/${MY_P}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
