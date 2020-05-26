# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${PN}-$(ver_rs 3 '-')

DESCRIPTION="AX.25 library for hamradio applications"
HOMEPAGE="http://www.linux-ax25.org/"
SRC_URI="http://www.linux-ax25.org/pub/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ~x86"
IUSE="static-libs"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf  $(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
	emake DESTDIR="${D}" installconf
}
