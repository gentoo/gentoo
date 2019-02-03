# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Encrypted UDP based FTP with multicast"
HOMEPAGE="http://uftp-multicast.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}-multicast/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+server ssl"

# openssl with EC required, see #644674
DEPEND="ssl? ( dev-libs/openssl:0=[-bindist] )"
RDEPEND="${DEPEND}"

# Workaround, see #644670
RESTRICT=test

PATCHES=(
	"${FILESDIR}/${PN}-4.9.4_makefile.patch"
)

src_compile() {
	use ssl || local opt="NO_ENCRYPTION=1"
	emake CC=$(tc-getCC) $opt uftp uftp_keymgt
	use server && emake CC=$(tc-getCC) $opt uftpd uftpproxyd
}

src_install() {
	dobin uftp uftp_keymgt
	dodoc {Changes,protocol,ReadMe}.txt
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

pkg_postinst() {
	if use server ; then
		ewarn "Please note, uftpd 4.x server is not backward compatible with"
		ewarn "uftp 3.x clients! Please upgrade clients before servers."
	fi
}
