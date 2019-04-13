# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit toolchain-funcs

DESCRIPTION="MiniSSDP Daemon"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"
HOMEPAGE="http://miniupnp.free.fr/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/libnfnetlink"

RDEPEND="$DEPEND
	|| ( net-misc/miniupnpd net-libs/miniupnpc )"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install () {
	emake PREFIX="${ED}" install
	# note: we overwrite upstream's init.d
	newinitd "${FILESDIR}/${PN}.initd-r2" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	dodoc Changelog.txt README
	doman minissdpd.1
}
