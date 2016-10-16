# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils ssl-cert toolchain-funcs

MY_P="linux-ftpd-${PV}"
DESCRIPTION="The netkit FTP server with optional SSL support"
HOMEPAGE="http://www.hcs.harvard.edu/~dholland/computers/netkit.html"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${MY_P}.tar.gz
	mirror://gentoo/${MY_P}-ssl.patch"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ~ppc64 s390 sh sparc x86"
IUSE="libressl ssl"

DEPEND="ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= ) )
"
RDEPEND="${DEPEND}
	virtual/inetd
	!www-servers/publicfile"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default

	cd "${S}" || die
	if use ssl; then
		epatch "${DISTDIR}"/${MY_P}-ssl.patch
		epatch "${FILESDIR}"/${P}-cleanup-ssl.patch
		epatch "${FILESDIR}"/${P}-fclose-CVE-2007-6263.patch #199206
	fi

	epatch "${FILESDIR}"/${P}-cleanup.patch
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-shadowfix.patch
	epatch "${FILESDIR}"/${P}-gcc41.patch
	epatch "${FILESDIR}"/${P}-setguid.patch
	epatch "${FILESDIR}"/${P}-cross.patch
	epatch "${FILESDIR}"/${P}-CVE-2008-4247.patch #239047
}

src_configure() {
	tc-export CC
	./configure --prefix=/usr || die
}

src_compile() {
	emake
}

src_install() {
	dobin ftpd/ftpd
	doman ftpd/ftpd.8
	dodoc README ChangeLog
	insinto /etc/xinetd.d
	newins "${FILESDIR}"/ftp.xinetd ftp
}

pkg_postinst() {
	if use ssl; then
		install_cert /etc/ssl/certs/ftpd
		elog "In order to start the server with SSL support"
		elog "You need a certificate /etc/ssl/certs/ftpd.pem."
		elog "A temporary certificiate has been created."
	fi
}
