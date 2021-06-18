# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A drop-in connection-time spam filter for qmail"
HOMEPAGE="http://www.spamdyke.org/"
SRC_URI="http://www.spamdyke.org/releases/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-libs/openssl-1.1.0:="

RDEPEND="
	${DEPEND}
	virtual/qmail
"

S="${WORKDIR}/${P}/${PN}"

PATCHES=( "${FILESDIR}/patch-for-openssl-1.1.patch" )
DOCS=( Changelog.txt INSTALL.txt UPGRADING.txt )

src_prepare() {
	default
	echo "# Configuration option for ${PN}" > "${PN}".conf || die
	echo "tls-certificate-file=/var/qmail/control/clientcert.pem" >> "${PN}".conf || die
	cat <<- EOF >> "${PN}".conf || die
graylist-level=always-create-dir
graylist-dir=/var/tmp/"${PN}"/graylist
reject-empty-rdns
reject-unresolvable-rdns
dns-blacklist-entry=zen.spamhaus.org
local-domains-file=/var/qmail/control/rcpthosts
EOF
	sed -i -e "/STRIP_CMD/d" Makefile.in || die "sed on Makefile.in failed"
	eautoreconf
}

src_configure() {
	econf $(use_with tls)
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dobin spamdyke
	insinto /etc/"${PN}"
	doins "${PN}".conf
	keepdir /var/tmp/"${PN}"/graylist
	fowners -R qmaild /var/tmp/"${PN}"/graylist
	cd ../documentation || die
	docinto html
	dodoc FAQ.html \
		README.html \
		README_ip_file_format.html \
		README_rdns_directory_format.html \
		README_rdns_file_format.html
}

pkg_postinst() {
	ewarn  "Change /var/qmail/control/conf-common:SOFTLIMIT_OPTS="-m 16000000""
	ewarn  "to 32000000 or spamdyke will fail to load"
	elog "In /var/qmail/control/conf-smtpd insert the line:"
	elog "QMAIL_SMTP_PRE=\"${QMAIL_SMTP_PRE} spamdyke -f /etc/${PN}/${PN}.conf\""
	elog "Run spamdyke with the '-h' flag to see the available options and"
	elog "update /etc/spamdyke/spamdyke.conf accordingly"
}
