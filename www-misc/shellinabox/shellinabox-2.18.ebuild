# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF="yes"
AUTOTOOLS_IN_SOURCE_BUILD="yes"

inherit user autotools-utils

DESCRIPTION="Web server that can export arbitrary command line tools to a web based terminal emulator"
HOMEPAGE="https://github.com/shellinabox/shellinabox"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+ssl +pam"

RDEPEND="${DEPEND}"
DEPEND="${RDEPEND}
	ssl? ( dev-libs/openssl:0= )
	pam? ( virtual/pam )"

SIAB_CERT_DIR="/etc/shellinabox/cert"
SIAB_SSL_BASH="${SIAB_CERT_DIR}/gen_ssl_cert.bash"
SIAB_DAEMON="${PN}d"

shellinbox_gen_ssl_setup() {
	read -r -d '' SIAB_SSL_SETUP << EOF
cd ${SIAB_CERT_DIR}
openssl genrsa -des3 -out server.key 1024
openssl req -new -key server.key -out server.csr
cp server.key server.key.org
openssl rsa -in server.key.org -out server.key
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
cat server.crt server.key > certificate.pem
EOF
}

pkg_setup() {
	enewgroup "${SIAB_DAEMON}"
	enewuser "${SIAB_DAEMON}" -1 -1 -1 "${SIAB_DAEMON}"
}

src_configure() {
	local myeconf="--disable-runtime-loading"

	econf \
		$(use_enable ssl) \
		$(use_enable pam) \
		"${myeconf}"
}

src_install() {
	emake DESTDIR="${D}" install || die

	# make installs the binary in bin.
	rm -rf "${D}/usr/bin" || die

	# whereas it should put it in sbin.
	dosbin "${SIAB_DAEMON}"

	# Install init+conf files.
	newinitd "${FILESDIR}/${SIAB_DAEMON}.init" "${SIAB_DAEMON}"
	newconfd "${FILESDIR}/${SIAB_DAEMON}.conf" "${SIAB_DAEMON}"

	# Install CSS files.
	insinto "/usr/share/${PN}-resources"
	doins -r "${PN}"/*.css

	if use ssl; then
		# Create directory where SSL certificates will be generated.
		dodir "${SIAB_CERT_DIR}"
		fowners "${SIAB_DAEMON}:${SIAB_DAEMON}" "${SIAB_CERT_DIR}"

		# Generate set up variable.
		shellinbox_gen_ssl_setup

		# Dump it in a bash script.
		echo "#!/usr/bin/env bash" > "${D}/${SIAB_SSL_BASH}" ||die
		echo "${SIAB_SSL_SETUP}" >> "${D}/${SIAB_SSL_BASH}" || die
		chmod +x "${D}/${SIAB_SSL_BASH}" || die
	fi
}

pkg_postinst() {
	ewarn
	ewarn "The default configuration expose a login shell"
	ewarn "with SSL disabled on the localhost interface only."
	ewarn

	if use ssl; then
		shellinbox_gen_ssl_setup

		einfo
		einfo "To generate self-signed SSL certificates"
		einfo "please read the following procedure"
		einfo "explained here: https://code.google.com/p/shellinabox/issues/detail?id=59#c15"
		einfo
		einfo "${SIAB_SSL_SETUP}"
		einfo
		einfo "This walkthrough has been written in ${SIAB_SSL_BASH} for your convenience."
		einfo "Make sure to execute this script."
		einfo
	fi
}
