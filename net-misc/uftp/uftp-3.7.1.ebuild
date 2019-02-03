# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Encrypted UDP based FTP with multicast"
HOMEPAGE="http://www.tcnj.edu/~bush/uftp.html"
SRC_URI="http://www.tcnj.edu/~bush/downloads/${P}.tar"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+server ssl"

DEPEND="ssl? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-3.7_makefile.patch"
)

src_compile() {
	use ssl || local opt="NO_ENCRYPTION=1"
	emake CC=$(tc-getCC) $opt uftp uftp_keymgt
	use server && emake CC=$(tc-getCC) $opt uftpd uftpproxyd
}

src_install() {
	dobin uftp uftp_keymgt
	dodoc ReadMe.txt
	doman uftp.1 uftp_keymgt.1

	if use server ; then
		dosbin uftpd uftpproxyd
		newinitd "${FILESDIR}/uftpd.init" uftpd
		newconfd "${FILESDIR}/uftpd.conf" uftpd
		newinitd "${FILESDIR}/uftpproxyd.init" uftpproxyd
		newconfd "${FILESDIR}/uftpproxyd.conf" uftpproxyd
		doman uftpd.1 uftpproxyd.1
		insinto /etc/logrotate.d
		newins "${FILESDIR}/logrotate" uftpd
	fi
}
