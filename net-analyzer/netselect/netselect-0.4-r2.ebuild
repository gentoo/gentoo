# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps toolchain-funcs

DESCRIPTION="Ultrafast implementation of ping"
HOMEPAGE="http://apenwarr.ca/netselect/"
SRC_URI="
	https://github.com/apenwarr/${PN}/archive/${P}.tar.gz
	ipv6? ( https://dev.gentoo.org/~jer/${P}-ipv6.patch.xz )
"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="ipv6"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4-bsd.patch
	"${FILESDIR}"/${PN}-0.4-flags.patch
)

DOCS=( HISTORY README )

FILECAPS=( -g wheel cap_net_raw /usr/bin/netselect )

src_prepare() {
	use ipv6 && eapply "${WORKDIR}"/${PN}-0.4-ipv6.patch

	default

	# Don't warn about "root privileges required" when running as
	# an unprivileged user with filecaps
	if ! use prefix && use filecaps; then
		sed -i -e '/if (geteuid () != 0)/,+2d' "${S}"/netselect.c || die
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin netselect

	einstalldocs

	doman netselect.1
}

pkg_postinst() {
	! use prefix && fcaps_pkg_postinst
}
