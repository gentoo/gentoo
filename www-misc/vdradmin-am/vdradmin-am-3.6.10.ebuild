# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils ssl-cert systemd user

DESCRIPTION="WWW Admin for the Video Disk Recorder"
HOMEPAGE="http://andreas.vdr-developer.org/vdradmin-am/index.html"
SRC_URI="http://andreas.vdr-developer.org/vdradmin-am/download/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6 ssl"

DEPEND="dev-lang/perl
	dev-perl/Template-Toolkit
	dev-perl/libwww-perl
	dev-perl/URI
	dev-perl/Locale-gettext
	virtual/perl-IO-Compress
	ipv6? ( dev-perl/IO-Socket-INET6 )
	ssl? ( dev-perl/IO-Socket-SSL )
	virtual/perl-libnet
	dev-perl/Authen-SASL
	dev-perl/Digest-HMAC"
RDEPEND="${DEPEND}"

ETC_DIR=/etc/vdradmin
CERTS_DIR=/etc/vdradmin/certs
LIB_DIR=/usr/share/vdradmin
CACHE_DIR=/var/cache/vdradmin
VDRADMIN_USER=vdradmin
VDRADMIN_GROUP=vdradmin

create_ssl_cert() {
	# The ssl-cert eclass is not flexible enough so do some steps manually
	SSL_ORGANIZATION="${SSL_ORGANIZATION:-vdradmin-am}"
	SSL_COMMONNAME="${SSL_COMMONNAME:-`hostname -f`}"

	gen_cnf || return 1

	gen_key 1 || return 1
	gen_csr 1 || return 1
	gen_crt 1 || return 1
}

pkg_setup() {
	enewgroup ${VDRADMIN_GROUP}
	enewuser ${VDRADMIN_USER} -1 /bin/bash ${CACHE_DIR} ${VDRADMIN_GROUP}
}

src_unpack() {
	unpack ${A}
	cp "${FILESDIR}"/vdradmind.service "${WORKDIR}"/vdradmind.service
}

src_prepare() {
	sed -i vdradmind.pl \
		-e "s-FILES_IN_SYSTEM    = 0;-FILES_IN_SYSTEM    = 1;-g" || die

	if use ipv6; then
		sed -e "s:/usr/bin/vdradmind:/usr/bin/vdradmind --ipv6:" \
			-i "${WORKDIR}"/vdradmind.service
	fi

	if use ssl; then
		sed -e "s:/usr/bin/vdradmind:/usr/bin/vdradmind --ssl:" \
			-i "${WORKDIR}"/vdradmind.service
	fi
}

src_install() {
	newinitd "${FILESDIR}"/vdradmin-3.6.7.init vdradmin
	newconfd "${FILESDIR}"/vdradmin-3.6.6.conf vdradmin

	systemd_dounit "${WORKDIR}"/vdradmind.service
	systemd_dotmpfilesd "${FILESDIR}"/vdradmind.conf

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/vdradmin-3.6.6.logrotate vdradmin

	newbin vdradmind.pl vdradmind

	insinto ${LIB_DIR}/template
	doins -r "${S}"/template/*

	insinto ${LIB_DIR}/lib/Template/Plugin
	doins -r "${S}"/lib/Template/Plugin/JavaScript.pm

	insinto /usr/share/locale/
	doins -r "${S}"/locale/*

	newman vdradmind.pl.1 vdradmind.8

	dodoc CREDITS ChangeLog FAQ HISTORY INSTALL README* REQUIREMENTS
	docinto contrib
	dodoc "${S}"/contrib/*

	diropts "-m755 -o ${VDRADMIN_USER} -g ${VDRADMIN_GROUP}"
	keepdir ${ETC_DIR}
	use ssl && keepdir ${CERTS_DIR}
}

pkg_preinst() {
	install -m 0644 -o ${VDRADMIN_USER} -g ${VDRADMIN_GROUP} /dev/null \
		"${D}"${ETC_DIR}/vdradmind.conf || die

	if [[ -f "${ROOT}"${ETC_DIR}/vdradmind.conf ]]; then
		cp "${ROOT}"${ETC_DIR}/vdradmind.conf \
			"${D}"${ETC_DIR}/vdradmind.conf || die
	else
		elog
		elog "Creating a new config-file."
		echo

		cat <<-EOF > "${D}"${ETC_DIR}/vdradmind.conf
			VDRCONFDIR = "${ROOT%/}"/etc/vdr
			VIDEODIR = "${ROOT%/}"/var/vdr/video
			EPG_FILENAME = "${ROOT%/}"/var/vdr/video/epg.data
			EPGIMAGES = "${ROOT%/}"/var/vdr/video/epgimages
			PASSWORD = gentoo-vdr
			USERNAME = gentoo-vdr
		EOF
		# Feed it with newlines
		yes "" \
			| "${D}"/usr/bin/vdradmind --cfgdir "${D}"${ETC_DIR} --config \
			|sed -e 's/: /: \n/g'

		[[ ${PIPESTATUS[1]} == "0" ]] \
			|| die "Failed to create initial configuration."

		elog
		elog "Created default user/password: gentoo-vdr/gentoo-vdr"
		elog
		elog "You can run \"emerge --config ${PN}\" if the default-values"
		elog "do not match your installation or change them in the Setup-Menu"
		elog "of the Web-Interface."
	fi
}

pkg_postinst() {
	if use ipv6; then
		elog
		elog "To make use of the ipv6 protocol"
		elog "you need to enable it in ${ROOT%/}/etc/conf.d/vdradmin"
	fi

	if use ssl; then
		elog
		elog "To use ssl connection to your vdr"
		elog "you need to enable it in ${ROOT%/}/etc/conf.d/vdradmin"

		if [[ ! -f "${ROOT}"${CERTS_DIR}/server-cert.pem || \
			! -f "${ROOT}"${CERTS_DIR}/server-key.pem ]]; then
			create_ssl_cert
			local base=$(get_base 1)
			install -D -m 0400 -o ${VDRADMIN_USER} -g ${VDRADMIN_GROUP} \
				"${base}".key "${ROOT}"${CERTS_DIR}/server-key.pem || die
			install -D -m 0444 -o ${VDRADMIN_USER} -g ${VDRADMIN_GROUP} \
				"${base}".crt "${ROOT}"${CERTS_DIR}/server-cert.pem || die
		fi
	fi

	elog
	elog "To extend ${PN} you can emerge"
	elog ">=media-plugins/vdr-epgsearch-0.9.25 to search the EPG,"
	elog "media-plugins/vdr-streamdev for livetv streaming and/or"
	elog "media-video/vdr with USE=\"liemikuutio/vasarajanauloja/none\" "
	elog "(depend on your vdr version) to rename recordings"
	elog "on the machine running the VDR you connect to with ${PN}."
}

pkg_config() {
	"${ROOT}"/usr/bin/vdradmind -c
}
