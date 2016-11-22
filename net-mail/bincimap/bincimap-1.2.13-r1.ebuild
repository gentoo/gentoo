# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="IMAP server for Maildir"
SRC_URI="http://www.bincimap.org/dl/tarballs/1.2/${P}final.tar.bz2"
HOMEPAGE="http://freshmeat.net/projects/bincimap/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="libressl ssl"

DEPEND="ssl? (
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
)"

RDEPEND="${DEPEND}
	virtual/daemontools
	sys-apps/ucspi-tcp
	net-mail/checkpassword"

# get rid of old style virtual - bug 350792
# all blockers really needed?
RDEPEND="${RDEPEND}
	!mail-mta/courier
	!net-mail/courier-imap
	!net-mail/cyrus-imapd
	!net-mail/uw-imap"

S="${WORKDIR}/${P}final"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.diff
	epatch "${FILESDIR}"/${PN}-1.2-gcc43.patch
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch
}

src_configure() {
	econf $(use_enable ssl) --sysconfdir=/etc/bincimap
}

src_compile() {
	emake localstatedir=/etc/bincimap
}

src_install () {
	emake DESTDIR="${D}" localstatedir=/etc/bincimap prefix=/usr install
	keepdir /var/log/bincimap || die
	use ssl && keepdir /var/log/bincimap-ssl || die

	dodoc AUTHORS ChangeLog INSTALL \
		NEWS README README.SSL TODO
	dohtml doc/*.{html,css}
	rm -rf "${D}"/usr/share/doc/"${PN}"

	# backward compatibility
	dosym /etc/bincimap/service/bincimap /etc/bincimap/service/imap
	dosym /etc/bincimap/service/bincimaps /etc/bincimap/service/imaps
}

pkg_postinst() {
	elog "To start bicimap at boot you have to enable the /etc/init.d/svscan rc file"
	elog "and create the following link:"
	elog "ln -s /etc/bincimap/service/bincimap /service/bincimap"
	elog

	if use ssl; then
		elog "If you want to use ssl connections, create the following link:"
		elog "ln -s /etc/bincimap/service/bincimaps /service/bincimaps"
		elog
		elog "And this command will setup bincimap-ssl on your system."
		elog "emerge --config =${CATEGORY}/${PF}"
		elog
	fi

	elog "NOTE: Default Maildir path is '~/.maildir'. If you want to modify it,"
	elog "edit /etc/bincimap/bincimap.conf"
	elog
}

pkg_config() {
	if use ssl; then
		local pemfile=/etc/bincimap/bincimap.pem
		if [ ! -f $pemfile ]; then
			echo "Creating a self-signed ssl-cert:"
			/usr/bin/openssl req -new -x509 -nodes -out $pemfile -days 366 -keyout $pemfile
			chmod 640 $pemfile

			einfo "If You want to have a signed cert, do the following:"
			einfo "openssl req -new -nodes -out req.pem \\"
			einfo "-keyout $pemfile"
			einfo "chmod 640 $pemfile"
			einfo "Send req.pem to your CA to obtain signed_req.pem, and do:"
			einfo "cat signed_req.pem >> $pemfile"
		fi
	fi
}
