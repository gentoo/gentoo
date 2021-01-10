# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit toolchain-funcs verify-sig

DESCRIPTION="MiniSSDP Daemon"
HOMEPAGE="http://miniupnp.free.fr/"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz
	verify-sig? ( http://miniupnp.free.fr/files/${P}.tar.gz.sig )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-libs/libnfnetlink"
RDEPEND="${DEPEND}
	|| ( net-misc/miniupnpd net-libs/miniupnpc )"
BDEPEND="
	verify-sig? ( app-crypt/openpgp-keys-miniupnp )"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/miniupnp.asc

src_configure() {
	sed -i -e '/#define HAVE_IP_MREQN/{s:/[*]::;s:[*]/::;}' config.h || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake PREFIX="${ED}" install
	# note: we overwrite upstream's init.d
	newinitd "${FILESDIR}/${PN}.initd-r2" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	dodoc Changelog.txt README
	doman minissdpd.1
}
