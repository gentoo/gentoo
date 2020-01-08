# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="util for flashing NSLU2 machines remotely"
HOMEPAGE="http://www.nslu2-linux.org/wiki/Main/UpSlug2"
SRC_URI="mirror://sourceforge/nslu/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

src_configure() {
	econf --sbindir "${EPREFIX}"/usr/bin
}

src_install() {
	default
	fperms 4711 /usr/bin/upslug2
}
