# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="tool for checking router configuration"
HOMEPAGE="http://packetfactory.openwall.net/projects/egressor/"
SRC_URI="http://packetfactory.openwall.net/projects/egressor/${PN}_release${PV}.tar.gz"
S="${WORKDIR}"

LICENSE="egressor"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="
	<net-libs/libnet-1.1
	>=net-libs/libnet-1.0.2a-r3
"
RDEPEND="
	net-libs/libpcap
	dev-perl/Net-RawIP
	dev-lang/perl
"
PATCHES=(
	"${FILESDIR}"/${PV}-libnet-1.0.patch
	"${FILESDIR}"/${PV}-flags.patch
)

src_compile() {
	tc-export CC
	emake -C client
}

src_install() {
	dobin client/egressor server/egressor_server.pl
	dodoc README client/README-CLIENT server/README-SERVER
}
