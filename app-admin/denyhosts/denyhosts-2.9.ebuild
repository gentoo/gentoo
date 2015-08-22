# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils readme.gentoo systemd

DESCRIPTION="DenyHosts is a utility to help sys admins thwart ssh hackers"
HOMEPAGE="http://denyhost.sourceforge.net/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ppc ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
>=net-misc/openssh-6.7p1 dropped support for sys-apps/tcp-wrappers
(see bug#531156) that means you either have patch openssh or use
denyhosts' iptables feature to get any protection.

You can configure DenyHosts to run as a daemon by running:
# rc-update add denyhosts default
or:
# systemctl enable denyhosts.service
(if you use systemd)

To run DenyHosts as a cronjob instead of a daemon add the following
to /etc/crontab
# run DenyHosts every 10 minutes
*/10  *  * * *    root    /usr/bin/denyhosts.py -c /etc/denyhosts.conf

More information can be found at ${HOMEPAGE}faq.html"

src_prepare() {
	#systemd needs HOSTNAME
	epatch "${FILESDIR}"/${PN}-2.6-hostname.patch

	sed -e '/^DENY_THRESHOLD_VALID =/s/=.*/= 5/' \
		-e '/^SECURE_LOG/s/^/#/' \
		-e '\@#SECURE_LOG.*/var/log/messages@s/^#//' \
		-i denyhosts.conf || die "sed failed"

	distutils-r1_src_prepare
}

src_install() {
	readme.gentoo_create_doc

	dodoc CHANGELOG.txt README.txt PKG-INFO
	distutils-r1_src_install

	dodir /etc/logrotate.d
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate-r2 ${PN}

	newinitd "${FILESDIR}"/denyhosts.init-r2 denyhosts
	systemd_dounit "${FILESDIR}"/${PN}.service

	keepdir /var/lib/denyhosts
}

pkg_postinst() {
	[[ -f "${EROOT}etc/hosts.deny" ]] || touch "${EROOT}etc/hosts.deny"

	readme.gentoo_print_elog
}
