# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools flag-o-matic

DESCRIPTION="FreeBSD Whois Client"
HOMEPAGE="https://www.freebsd.org/"
SRC_URI="http://utenti.gufi.org/~drizzt/codes/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

PATCHES=(
	"${FILESDIR}/${PN}-1.43.2.1-musl-cdefs.patch"
	"${FILESDIR}/${PN}-1.43.2.1-clang16-build.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug #875029
	append-cppflags -D_GNU_SOURCE
	default
}

src_install() {
	default

	mv "${ED}"/usr/share/man/man1/{whois,bsdwhois}.1 || die
	mv "${ED}"/usr/bin/{whois,bsdwhois} || die
}
