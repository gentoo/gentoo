# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openntpd/openntpd-4.0_pre20080406.ebuild,v 1.4 2015/05/26 14:31:03 ottxor Exp $

EAPI=5

inherit autotools eutils toolchain-funcs systemd user

MY_PV=${PV##*pre}
MY_P="${PN}_${MY_PV}p"
DEB_VER="6"
DESCRIPTION="Lightweight NTP server ported from OpenBSD"
HOMEPAGE="http://www.openntpd.org/"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${MY_P}-${DEB_VER}.debian.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="ssl selinux"

CDEPEND="ssl? ( dev-libs/openssl )
	!<=net-misc/ntp-4.2.0-r2
	!net-misc/ntp[-openntpd]"
DEPEND="${CDEPEND}
	virtual/yacc"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-ntp )
"

S="${WORKDIR}/${MY_P/_/-}"

pkg_setup() {
	export NTP_HOME="${NTP_HOME:=/var/lib/openntpd/chroot}"
	enewgroup ntp
	enewuser ntp -1 -1 "${NTP_HOME}" ntp

	# make sure user has correct HOME as flipng between
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
	sed -i '/NTPD_USER/s:_ntp:ntp:' ntpd.h || die

	epatch "${WORKDIR}"/debian/patches/*.patch
	epatch "${FILESDIR}/${PN}-${MY_PV}-pidfile.patch"
	epatch "${FILESDIR}/${PN}-${MY_PV}-signal.patch"
	epatch "${FILESDIR}/${PN}-${MY_PV}-dns-timeout.patch"
	sed -i 's:debian:gentoo:g' ntpd.conf || die
	eautoreconf # deb patchset touches .ac files and such
}

src_configure() {
	econf \
		--disable-strip \
		$(use_with !ssl builtin-arc4random) \
		AR="$(type -p $(tc-getAR))"
}

src_install() {
	default
	rmdir "${ED}"/{var/empty,var}

	newinitd "${FILESDIR}/${PN}.init.d-${MY_PV}-r6" ntpd
	newconfd "${FILESDIR}/${PN}.conf.d-${MY_PV}-r6" ntpd

	systemd_newunit "${FILESDIR}/${PN}.service-${MY_PV}-r4" ntpd.service
}

pkg_config() {
	einfo "Setting up chroot for ntp in ${NTP_HOME}"
	# remove localtime file from previous installations
	rm -f "${EROOT%/}${NTP_HOME}"/etc/localtime
	mkdir -p "${EROOT%/}${NTP_HOME}"/etc
	if ! ln "${EROOT%/}"/etc/localtime "${EROOT%/}${NTP_HOME}"/etc/localtime ; then
		cp "${EROOT%/}"/etc/localtime "${EROOT%/}${NTP_HOME}"/etc/localtime || die
		einfo "We could not create a hardlink from /etc/localtime to ${NTP_HOME}/etc/localtime,"
		einfo "so please run 'emerge --config =${CATEGORY}/${PF}' whenever you changed"
		einfo "your timezone."
	fi
	chown -R root:root "${EROOT%/}${NTP_HOME}" || die
}

pkg_postinst() {
	pkg_config

	[[ -f ${EROOT}var/log/ntpd.log ]] && \
		ewarn "There is an orphaned logfile '${EROOT}var/log/ntpd.log', please remove it!"

	# bug #226491, remove <=openntpd-20080406-r7 trash
	rm -f "${EROOT%/}${NTP_HOME}"etc/localtime
	[-d "${EROOT%/}${NTP_HOME}"etc ] && rmdir "${EROOT%/}${NTP_HOME}"etc
}

pkg_postrm() {
	# remove localtime file from previous installations
	rm -f "${EROOT%/}${NTP_HOME}"/etc/localtime
}
