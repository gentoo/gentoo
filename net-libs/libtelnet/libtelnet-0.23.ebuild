# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Simple RFC-compliant TELNET implementation as a C library"
HOMEPAGE="https://github.com/seanmiddleditch/libtelnet"
SRC_URI="https://github.com/seanmiddleditch/libtelnet/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${D}" -type f -name '*.a' -delete || die
}
