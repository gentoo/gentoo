# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

COMMIT="d8f91af976c97a6006a5bd1ad7149380c39ba454"
DESCRIPTION="httptunnel can create IP tunnels through firewalls/proxies using HTTP"
HOMEPAGE="https://github.com/larsbrinkhoff/httptunnel"
SRC_URI="https://github.com/larsbrinkhoff/httptunnel/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=(
	"${FILESDIR}/${PN}-3.3_p20180119-respect-AR.patch"
)

src_prepare() {
	default

	tc-export AR RANLIB
	eautoreconf
}

src_configure() {
	# bug #943924
	append-cflags -std=gnu17

	default
}
