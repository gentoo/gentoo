# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs verify-sig

DESCRIPTION="MiniSSDP Daemon"
HOMEPAGE="
	http://miniupnp.free.fr/
	https://miniupnp.tuxfamily.org/
	https://github.com/miniupnp/miniupnp/
"
SRC_URI="
	https://miniupnp.tuxfamily.org/files/${P}.tar.gz
	verify-sig? (
		https://miniupnp.tuxfamily.org/files/${P}.tar.gz.sig
	)
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-libs/libnfnetlink
"
RDEPEND="
	${DEPEND}
	|| ( net-misc/miniupnpd net-libs/miniupnpc )
"
BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-miniupnp )
"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/miniupnp.asc

src_configure() {
	sed -i -e '/#define HAVE_IP_MREQN/{s:/[*]::;s:[*]/::;}' config.h || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${ED}" install
	# note: we overwrite upstream's init.d
	newinitd "${FILESDIR}/${PN}.initd-r2" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	dodoc Changelog.txt README
	doman minissdpd.1
}
