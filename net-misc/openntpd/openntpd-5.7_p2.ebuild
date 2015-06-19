# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openntpd/openntpd-5.7_p2.ebuild,v 1.1 2015/01/25 00:54:30 ottxor Exp $

EAPI=5

inherit autotools eutils systemd user

DESCRIPTION="Lightweight NTP server ported from OpenBSD"
HOMEPAGE="http://www.openntpd.org/"

MY_P="${P/_p/p}"
SRC_URI="mirror://openbsd/OpenNTPD/${MY_P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="selinux"

CDEPEND="!<=net-misc/ntp-4.2.0-r2
	!net-misc/ntp[-openntpd]"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-ntp )
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	export NTP_HOME="${NTP_HOME:=/var/lib/openntpd/chroot}"
	enewgroup ntp
	enewuser ntp -1 -1 "${NTP_HOME}" ntp

	# make sure user has correct HOME as flipping between
	# the standard ntp pkg and this one was possible in
	# the past
	if [[ $(egethome ntp) != ${NTP_HOME} ]]; then
		ewarn "From this version on, the homedir of the ntp user cannot be changed"
		ewarn "dynamically after the installation. For homedir different from"
		ewarn "/var/lib/openntpd/chroot set NTP_HOME in your make.conf and re-emerge."
		esethome ntp "${NTP_HOME}"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-5.7_p1-runpath.patch"
	epatch "${FILESDIR}/${PN}-5.7_p1-driftpath.patch"
	epatch "${FILESDIR}/${PN}-5.7_p1-gentoopool.patch"
	epatch "${FILESDIR}/${P}-adjtimex.patch"
	epatch "${FILESDIR}/${P}-proctitle.patch"
	#Due to last patch
	eautoreconf
}

src_configure() {
	econf --with-privsep-user=ntp --with-privsep-path="${NTP_HOME}"
}

src_install() {
	default
	rm -r "${ED}"/var

	newinitd "${FILESDIR}/${PN}.init.d-20080406-r6" ntpd
	newconfd "${FILESDIR}/${PN}.conf.d-20080406-r6" ntpd

	systemd_newunit "${FILESDIR}/${PN}.service-20080406-r4" ntpd.service
}

pkg_config() {
	einfo "Setting up chroot for ntp in ${NTP_HOME}"
	# remove localtime file from previous installations
	rm -f "${EROOT%/}${NTP_HOME}"/etc/localtime
	mkdir -p "${EROOT%/}${NTP_HOME}"/etc
	if ! ln "${EROOT%/}"/etc/localtime "${EROOT%/}${NTP_HOME}"/etc/localtime ; then
		cp "${EROOT%/}"/etc/localtime "${EROOT%/}${NTP_HOME}"/etc/localtime || die
		einfo "We could not create a hardlink from /etc/localtime to ${NTP_HOME}/etc/localtime,"
		einfo "so please run 'emerge --config =${CATEGORY}/${PF}' whenever you change"
		einfo "your timezone."
	fi
	chown -R root:root "${EROOT%/}${NTP_HOME}" || die
}

pkg_postinst() {
	pkg_config

	[[ -f ${EROOT}var/log/ntpd.log ]] && \
		ewarn "Logfile '${EROOT}var/log/ntpd.log' might be orphaned, please remove it if not in use via syslog."

	if [[ -f ${EROOT}var/lib/ntpd.drift ]] ; then
		einfo "Moving ntpd.drift file to new location."
		mv "${EROOT}var/lib/ntpd.drift" "${EROOT}var/lib/openntpd/ntpd.drift"
	fi
}

pkg_postrm() {
	# remove localtime file from previous installations
	rm -f "${EROOT%/}${NTP_HOME}"/etc/localtime
}
