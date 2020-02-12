# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 toolchain-funcs

DESCRIPTION="Ultrafast implementation of ping"
HOMEPAGE="http://apenwarr.ca/netselect/"
EGIT_REPO_URI="
	https://github.com/apenwarr/${PN}
"
SRC_URI="
	ipv6? ( https://dev.gentoo.org/~jer/${PN}-0.4-ipv6.patch.xz )
"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="ipv6"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4-bsd.patch
	"${FILESDIR}"/${PN}-0.4-flags.patch
)

src_unpack() {
	use ipv6 && unpack ${A}
	git-r3_src_unpack
}

src_prepare() {
	use ipv6 && PATCHES+=( "${WORKDIR}"/${PN}-0.4-ipv6.patch )

	default
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${CFLAGS} ${LDFLAGS}"
}

src_install () {
	dobin netselect

	if ! use prefix ; then
		fowners root:wheel /usr/bin/netselect
		fperms 4711 /usr/bin/netselect
	fi

	dodoc HISTORY README

	doman netselect.1
}
