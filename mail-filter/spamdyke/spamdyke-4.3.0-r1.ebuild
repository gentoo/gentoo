# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils autotools

DESCRIPTION="A drop-in connection-time spam filter for qmail"
HOMEPAGE="http://www.spamdyke.org/"
SRC_URI="http://www.spamdyke.org/releases/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl +ssl"

DEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)"
RDEPEND="${DEPEND}
	virtual/qmail"

S=${WORKDIR}/${P}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc46.patch
	echo "# Configuration option for ${PN}" > ${PN}.conf
	if use ssl; then
		echo "tls-certificate-file=/var/qmail/control/clientcert.pem" \
			>> ${PN}.conf
	fi
	echo "graylist-level=always-create-dir" >> ${PN}.conf
	echo "graylist-dir=/var/tmp/${PN}/graylist" >> ${PN}.conf
	echo "reject-empty-rdns" >> ${PN}.conf
	echo "reject-unresolvable-rdns" >> ${PN}.conf
	echo "dns-blacklist-entry=zen.spamhaus.org" >> ${PN}.conf
	echo "local-domains-file=/var/qmail/control/rcpthosts" >> ${PN}.conf
	sed -i \
		-e "/STRIP_CMD/d" \
		Makefile.in || die "sed on Makefile.in failed"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable ssl tls) || die "econf failed"
	cd ../utils
	econf || die "econf failed in utils"
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "emake failed"
	cd ../utils
	emake CFLAGS="${CFLAGS}" || die "emake in utils died"
}

src_install() {
	dobin ${PN} || die "Installing ${PN} binary failed"
	insinto /etc/${PN}
	doins ${PN}.conf || die "Installing ${PN} configuration file failed"
	dodir /var/tmp/${PN}/graylist
	fowners -R qmaild /var/tmp/${PN}/graylist
	cd ../utils
	dobin domain2path || die "Installing domain2path binary failed"
	cd ../documentation
	dodoc {Changelog,INSTALL,UPGRADING}.txt
	dohtml FAQ.html \
		README.html \
		README_ip_file_format.html \
		README_rdns_directory_format.html \
		README_rdns_file_format.html
}

pkg_postinst() {
	elog "In /var/qmail/control/conf-smtpd insert the line:"
	elog "QMAIL_SMTP_PRE=\"${QMAIL_SMTP_PRE} spamdyke -f /etc/${PN}/${PN}.conf\""
	elog "Run spamdyke with the '-h' flag to see the available options and"
	elog "update /etc/spamdyke/spamdyke.conf accordingly"
}
