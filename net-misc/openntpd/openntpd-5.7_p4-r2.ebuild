# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils systemd user

MY_P="${P/_p/p}"
DESCRIPTION="Lightweight NTP server ported from OpenBSD"
HOMEPAGE="http://www.openntpd.org/"
SRC_URI="mirror://openbsd/OpenNTPD/${MY_P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="selinux"

DEPEND="!<=net-misc/ntp-4.2.0-r2
	!net-misc/ntp[-openntpd]"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-ntp )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	export NTP_HOME="${NTP_HOME:=/var/lib/openntpd/chroot}"
	enewgroup ntp
	enewuser ntp -1 -1 "${NTP_HOME}" ntp

	# make sure user has correct HOME as flipping between the standard ntp pkg
	# and this one was possible in the past
	if [[ $(egethome ntp) != ${NTP_HOME} ]]; then
		ewarn "From this version on, the homedir of the ntp user cannot be changed"
		ewarn "dynamically after the installation. For homedir different from"
		ewarn "/var/lib/openntpd/chroot set NTP_HOME in your make.conf and re-emerge."
		esethome ntp "${NTP_HOME}"
	fi
}

src_prepare() {
	# add fail constraints when no libtls patch (accepted upstream)
	epatch "${FILESDIR}/${P}-nolibtls.patch"
	# fix /run path
	sed -i 's:/var/run/ntpd:/run/ntpd:g' src/ntpctl.8 src/ntpd.8 || die
	sed -i 's:LOCALSTATEDIR "/run/ntpd:"/run/ntpd:' src/ntpd.h || die
	# fix ntpd.drift path
	sed -i 's:/var/db/ntpd.drift:/var/lib/openntpd/ntpd.drift:g' src/ntpd.8 || die
	sed -i 's:"/db/ntpd.drift":"/openntpd/ntpd.drift":' src/ntpd.h || die
	# fix default config to use gentoo pool
	sed -i 's:servers pool.ntp.org:#servers pool.ntp.org:' ntpd.conf || die
	printf "\n# Choose servers announced from Gentoo NTP Pool\nservers 0.gentoo.pool.ntp.org\nservers 1.gentoo.pool.ntp.org\nservers 2.gentoo.pool.ntp.org\nservers 3.gentoo.pool.ntp.org\n" >> ntpd.conf || die
}

src_configure() {
	econf --with-privsep-user=ntp
}

src_install() {
	default
	rm -r "${ED}"/var

	newinitd "${FILESDIR}/${PN}.init.d-20080406-r6" ntpd
	newconfd "${FILESDIR}/${PN}.conf.d-20080406-r6" ntpd

	systemd_newunit "${FILESDIR}/${PN}.service-20080406-r4" ntpd.service
}

pkg_postinst() {
	# Clean up chroot localtime copy from older versions
	if [ -d "${EROOT%/}${NTP_HOME}"/etc ] ; then
		if [ -f "${EROOT%/}${NTP_HOME}"/etc/localtime ] ; then
			rm -f "${EROOT%/}${NTP_HOME}"/etc/localtime
		fi

		rmdir "${EROOT%/}${NTP_HOME}"/etc ||
			ewarn "Unable to remove legacy ${EROOT%/}${NTP_HOME}/etc directory"
	fi

	# Fix permissions on home directory
	chown root:root "${EROOT%/}${NTP_HOME}" || die

	[[ -f ${EROOT}var/log/ntpd.log ]] && \
		ewarn "Logfile '${EROOT}var/log/ntpd.log' might be orphaned, please remove it if not in use via syslog."

	if [[ -f ${EROOT}var/lib/ntpd.drift ]] ; then
		einfo "Moving ntpd.drift file to new location."
		mv "${EROOT}var/lib/ntpd.drift" "${EROOT}var/lib/openntpd/ntpd.drift"
	fi
}
