# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils versionator autotools

FAX_SPOOL_DIR="${ROOT}/var/spool/fax"

MY_PV1="$(get_version_component_range 1-4)"
MY_PV2="$(get_version_component_range 5)"
MY_PV3="$(get_version_component_range 6)"
MY_P="${PN}_${MY_PV1}.svn.${MY_PV2}"

DESCRIPTION="capi4hylafax adds a faxcapi modem to the hylafax enviroment"
SRC_URI="mirror://debian/pool/main/c/capi4hylafax/${MY_P}.orig.tar.gz
		mirror://debian/pool/main/c/capi4hylafax/${MY_P}-${MY_PV3}.debian.tar.gz"
HOMEPAGE="http://packages.qa.debian.org/c/capi4hylafax.html"

S="${WORKDIR}/${PN}-svn"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="net-dialup/capi4k-utils
	app-shells/bash:0
	media-libs/tiff:0
	virtual/jpeg:0
	sys-libs/zlib"

RDEPEND="${DEPEND}
	dev-util/dialog"

DOCS=( AUTHORS ChangeLog Readme_src )
HTML_DOCS=( README.html LIESMICH.html )

src_prepare() {
	EPATCH_SOURCE="${WORKDIR}/debian/patches" EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" epatch

	eapply_user

	eautoreconf

	mv ../debian . || die

	# fix location of fax spool
	sed -e "s:/var/spool/hylafax:${FAX_SPOOL_DIR}:g" \
		-i config.faxCAPI \
		-i Readme_src \
		-i src/defaults.h.in \
		-i debian/*.1 || die

	# fix location of fax config
	sed -i -e "s:/etc/hylafax:${FAX_SPOOL_DIR}/etc:g" setupconffile || die

	# fix name and location of logfile
	sed -e "s:/var/spool/fax/log/capi4hylafax:/var/log/${PN}.log:" \
		-i config.faxCAPI || die

	sed -e "s:/tmp/capifax.log:/var/log/${PN}.log:" \
		-i src/defaults.h.in config.faxCAPI || die

	# patch man pages
	sed -e "s:/usr/share/doc/capi4hylafax/:/usr/share/doc/${PF}/html/:g" \
		-e "s:c2send:c2faxsend:g" \
		-e "s:c2recv:c2faxrecv:g" \
		-e "s:CAPI4HYLAFAXCONFIG \"1\":C2FAXADDMODEM \"8\":g" \
		-e "s:capi4hylafaxconfig:c2faxaddmodem:g" \
		-i debian/*.1 || die

	cp -f debian/capi4hylafaxconfig.1 debian/c2faxaddmodem.8 || die
}

src_configure() {
	econf --with-hylafax-spooldir="${FAX_SPOOL_DIR}"
}

src_install() {
	keepdir "${FAX_SPOOL_DIR}"/{etc,recvq,pollq,log,status}
	fowners uucp:uucp "${FAX_SPOOL_DIR}" "${FAX_SPOOL_DIR}"/{etc,recvq,pollq,log,status}
	fperms 0700 "${FAX_SPOOL_DIR}"

	default

	# install setup script
	newsbin setupconffile c2faxaddmodem

	# install sample config
	insinto "${FAX_SPOOL_DIR}/etc"
	newins config.faxCAPI config.faxCAPI.default

	# install docs
	newdoc debian/changelog ChangeLog.debian

	# install man pages
	doman debian/c2fax*.[18]

	# install examples
	insinto /usr/share/doc/${PF}/examples
	doins sample_faxrcvd config.faxCAPI fritz_pic.tif GenerateFileMail.pl
	newins sample_AVMC4_config.faxCAPI config.faxCAPI_AVMC4
	newins debian/faxsend sample_faxsend

	# finally install init-script + config
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
}

pkg_postinst() {
	einfo
	elog "To use capi4hylafax:"
	elog "Make sure that your isdn/capi devices are owned by"
	elog "the \"uucp\" user (see udev or devfsd config)."
	elog "Modify ${FAX_SPOOL_DIR}/etc/config.faxCAPI"
	elog "to suit your system."

	if [ -n "${REPLACING_VERSIONS}" ]; then
		elog
		elog "If you're upgrading from a previous version"
		elog "please check for new or changed options."
		elog "A sample default config is installed as:"
		elog "${FAX_SPOOL_DIR}/etc/config.faxCAPI.default"
	else
		elog
		elog "Please run package config to install a default configuration."
	fi

	elog
	elog "You should also check special options in:"
	elog "/etc/conf.d/${PN}"
	elog
	elog "The following optional dependency is also available:"
	optfeature "hylafax integration" net-misc/hylafax
	elog
	elog "Then append the following line to your hylafax"
	elog "config file (${FAX_SPOOL_DIR}/etc/config):"
	elog "SendFaxCmd:			 /usr/bin/c2faxsend"
	einfo
}

pkg_config() {
	local config_file="${FAX_SPOOL_DIR}/etc/config.faxCAPI"
	if [ -e "${config_file}" ]; then
		eerror "The configuration file already exists. Please either update"
		eerror "or remove this file and re-run package configuration."
		eerror "Configuration file location: ${config_file}"
	else
		elog "Installing template configuration file to ${config_file}"
		cp -f "${FAX_SPOOL_DIR}/etc/config.faxCAPI.default" \
			"${config_file}" || die
	fi
}
