# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ssl-cert systemd tmpfiles

DESCRIPTION="WWW Admin for the Video Disk Recorder"
HOMEPAGE="http://andreas.vdr-developer.org/vdradmin-am/index.html"
SRC_URI="https://github.com/vdr-projects/vdradmin-am/archive/refs/tags/v${PV}.tar.gz -> ${P}.tgz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6 systemd"

DEPEND="acct-user/vdradmin
	dev-lang/perl
	dev-perl/Authen-SASL
	dev-perl/CGI
	dev-perl/Digest-HMAC
	dev-perl/HTTP-Daemon
	dev-perl/Locale-gettext
	dev-perl/Template-Toolkit
	dev-perl/URI
	dev-perl/libwww-perl
	virtual/perl-IO-Compress
	virtual/perl-libnet
	ipv6? ( dev-perl/IO-Socket-INET6 )
	ssl? ( dev-perl/HTTP-Daemon-SSL )
	systemd? ( sys-apps/systemd )"
RDEPEND="${DEPEND}
	app-admin/sudo"
BDEPEND="
	acct-user/vdradmin
	sys-devel/gettext"
PATCHES=( "${FILESDIR}/timerlist_prio_lifetime_addon.patch" )

ETC_DIR="/etc/vdradmin"
CERTS_DIR="/etc/vdradmin/certs"
LIB_DIR="/usr/share/vdradmin"
VDRADMIN_USER="vdradmin"
VDRADMIN_GROUP="vdradmin"

create_ssl_cert() {
	elog "Create and install SSL certificate"
	SSL_ORGANIZATION="VDR vdradmin-am"
	SSL_COMMONNAME=$("${ROOT}"/bin/hostname -f)
	elog "install_cert ${CERTS_DIR}/server-cert.pem for host $SSL_COMMONNAME"
	rm -f "${ROOT}${CERTS_DIR}/server-cert.pem" "${ROOT}${CERTS_DIR}/server-key.pem" || die
	install_cert "${ROOT}${CERTS_DIR}/vdradmin"
	ls -la "${ROOT}${CERTS_DIR}/"
	rm -f "${ROOT}${CERTS_DIR}/vdradmin.csr" "${ROOT}${CERTS_DIR}/vdradmin.pem" || die
	mv "${ROOT}${CERTS_DIR}/vdradmin.key" "${ROOT}${CERTS_DIR}/server-key.pem" || die
	mv "${ROOT}${CERTS_DIR}/vdradmin.crt" "${ROOT}${CERTS_DIR}/server-cert.pem" || die
	chown "${VDRADMIN_USER}":"${VDRADMIN_GROUP}" "${ROOT}${CERTS_DIR}/server-cert.pem" || die
	chown "${VDRADMIN_USER}":"${VDRADMIN_GROUP}" "${ROOT}${CERTS_DIR}/server-key.pem" || die
}

src_unpack() {
	unpack ${A}
	cp "${FILESDIR}"/vdradmind.service "${WORKDIR}"/vdradmind.service || die
}

src_prepare() {
	default

	sed -i vdradmind.pl \
		-e "s|FILES_IN_SYSTEM\s*=\s*0;|FILES_IN_SYSTEM = 1;|" || die
}

src_install() {
	newinitd "${FILESDIR}"/vdradmin-3.6.7.init vdradmin
	newconfd "${FILESDIR}"/vdradmin-3.6.10.conf vdradmin

	systemd_dounit "${WORKDIR}"/vdradmind.service
	dotmpfiles "${FILESDIR}"/vdradmind.conf

	exeinto /usr/share/vdradmin/systemd
	doexe "${FILESDIR}"/vdradmin-systemd-helper.sh

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/vdradmin-3.6.6.logrotate vdradmin

	newbin vdradmind.pl vdradmind

	insinto "${LIB_DIR}"/template
	doins -r "${S}"/template/*

	insinto "${LIB_DIR}"/lib/Template/Plugin
	doins -r "${S}"/lib/Template/Plugin/JavaScript.pm

	newman vdradmind.pl.1 vdradmind.8

	dodoc CREDITS FAQ HISTORY INSTALL README* REQUIREMENTS
	docinto contrib
	dodoc "${S}"/contrib/*

	keepdir "${ETC_DIR}"
	fowners "${VDRADMIN_USER}":"${VDRADMIN_GROUP}" "${ETC_DIR}"

	if use ssl; then
		keepdir "${CERTS_DIR}"
		fowners "${VDRADMIN_USER}":"${VDRADMIN_GROUP}" "${CERTS_DIR}"
	fi

	mkdir -p "${ED}/etc/sudoers.d/" || die
	echo "vdradmin ALL=NOPASSWD:/bin/systemctl daemon-reload" > "${ED}/etc/sudoers.d/${PN}" || die
	chmod 0440 "${ED}/etc/sudoers.d/${PN}" || die

	local PO L
	for PO in po/*.po
	do
		L=$(basename $PO .po)
		insinto /usr/share/locale/${L}/LC_MESSAGES/
		msgfmt po/${L}.po -o po/${L}.mo
		newins po/${L}.mo vdradmin.mo
	done

}

pkg_preinst() {
	install -m 0644 -o ${VDRADMIN_USER} -g ${VDRADMIN_GROUP} /dev/null \
		"${ED}"${ETC_DIR}/vdradmind.conf || die

	if [[ -f "${EROOT}"${ETC_DIR}/vdradmind.conf ]]; then
		cp "${EROOT}"${ETC_DIR}/vdradmind.conf \
			"${ED}"${ETC_DIR}/vdradmind.conf || die
	else
		elog
		elog "Creating a new config-file."
		echo

		cat <<-EOF > "${ED}"${ETC_DIR}/vdradmind.conf
			VDRCONFDIR = /etc/vdr
			VIDEODIR = /var/vdr/video
			EPG_FILENAME = /var/vdr/video/epg.data
			EPGIMAGES = /var/vdr/video/epgimages
			PASSWORD = gentoo-vdr
			USERNAME = gentoo-vdr
			VDR_PORT = 6419
		EOF
		# Feed it with newlines
		yes "" \
			| "${ED}"/usr/bin/vdradmind --cfgdir "${ED}"${ETC_DIR} --config \
			|sed -e 's|: |: \n|g'

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
	tmpfiles_process vdradmind.conf

	if use ipv6; then
		elog
		elog "To make use of the ipv6 protocol"
		elog "you need to enable it in ${EROOT}/etc/conf.d/vdradmin"
	fi

	if use ssl; then
		elog
		elog "To use ssl connection to your vdradmin"
		elog "you need to enable it in ${EROOT}/etc/conf.d/vdradmin"

		# only create a certificate if none exists
		if [[ -f ${ROOT}${CERTS_DIR}/server-cert.pem ]]; then
			elog "Existing SSL cert found, not touching it."
		else
			elog "No SSL cert found, creating a default one now"
			create_ssl_cert
		fi
	fi

	if [[ ! -f "${EROOT}"${ETC_DIR}/vdradmin-systemd.env ]]; then
		echo "# systemd environment file, created by pre-exec script, do not edit!" \
			> "${EROOT}"${ETC_DIR}/vdradmin-systemd.env
		chown "${VDRADMIN_USER}":"${VDRADMIN_GROUP}" "${EROOT}"${ETC_DIR}/vdradmin-systemd.env || die
	fi

	elog
	elog "To extend the functionality of ${PN} you can emerge"
	elog "  media-plugins/vdr-epgsearch to search the EPG"
	elog "  media-plugins/vdr-streamdev for livetv streaming"
	elog "on the machine running the VDR you connect to with ${PN}."
}

pkg_config() {
	"${EROOT}"/usr/bin/vdradmind -c
}
