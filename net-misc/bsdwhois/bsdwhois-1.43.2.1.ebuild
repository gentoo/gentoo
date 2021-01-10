# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="FreeBSD Whois Client"
HOMEPAGE="https://www.freebsd.org/"
SRC_URI="http://utenti.gufi.org/~drizzt/codes/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="userland_BSD"

PATCHES=(
	"${FILESDIR}/${PN}-1.43.2.1-musl-cdefs.patch"
)

src_install() {
	default

	if ! use userland_BSD; then
		mv "${ED}"/usr/share/man/man1/{whois,bsdwhois}.1 || die
		mv "${ED}"/usr/bin/{whois,bsdwhois} || die
	fi
}
