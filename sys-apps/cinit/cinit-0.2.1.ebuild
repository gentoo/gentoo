# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="a fast, small and simple init with support for profiles"
HOMEPAGE="http://linux.schottelius.org/cinit/"
SRC_URI="http://linux.schottelius.org/${PN}/archives/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="doc"

src_prepare() {
	sed -i "/contrib+tools/d" Makefile || die
	sed -i "/^STRIP/s/strip.*/true/" Makefile.include || die
	default
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -I." \
		LDFLAGS="${LDFLAGS}" \
		STRIP=/bin/true \
		all
}

src_install() {
	emake LD="$(tc-getCC)" DESTDIR="${D}" install
	rm -f "${D}"/sbin/{init,shutdown,reboot} || die
	dodoc Changelog CHANGES CREDITS README TODO
	use doc && dodoc -r doc
}
