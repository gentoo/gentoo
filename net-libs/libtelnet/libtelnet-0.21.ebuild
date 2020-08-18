# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

DESCRIPTION="Simple RFC-complient TELNET implementation as a C library"
HOMEPAGE="https://github.com/seanmiddleditch/libtelnet"
SRC_URI="https://github.com/seanmiddleditch/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

WANT_AUTOMAKE=1.11
DEPEND="${DEPEND} sys-devel/automake:${WANT_AUTOMAKE}"

src_prepare() {
	_elibtoolize
	eaclocal
	eautoconf
	eautoheader
	eautomake
}

src_install() {
	default
	find "${D}" -type f -name '*.a' -delete || die
}
