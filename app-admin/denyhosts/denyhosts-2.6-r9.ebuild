# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils readme.gentoo systemd

MY_PN="DenyHosts"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="DenyHosts is a utility to help sys admins thwart ssh hackers"
HOMEPAGE="http://www.denyhosts.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
You can configure DenyHosts to run as a daemon by running:
# rc-update add denyhosts default
or:
# systemctl enable denyhosts.service
(if you use systemd)

To run DenyHosts as a cronjob instead of a daemon add the following
to /etc/crontab
# run DenyHosts every 10 minutes
*/10  *  * * *    root    /usr/bin/denyhosts.py -c /etc/denyhosts.conf

More information can be found at http://denyhosts.sourceforge.net/faq.html"

src_prepare() {
	# changes default file installations
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-log-injection-regex.patch

	# Multiple patches from Fedora and Debian
	epatch "${FILESDIR}"/${P}-daemon-control.patch
	epatch "${FILESDIR}"/${P}-defconffile.patch
	epatch "${FILESDIR}"/${P}-foreground_mode.patch
	epatch "${FILESDIR}"/${P}-hostname.patch
	epatch "${FILESDIR}"/${P}-plugin_deny.patch
	epatch "${FILESDIR}"/${P}-single_config_switch.patch

	epatch "${FILESDIR}"/${P}-cve-2013-6890.patch

	sed -i -e 's:DENY_THRESHOLD_VALID = 10:DENY_THRESHOLD_VALID = 5:' \
		denyhosts.cfg-dist || die "sed failed"

	distutils-r1_src_prepare
}

src_install() {
	readme.gentoo_create_doc

	dodoc CHANGELOG.txt README.txt PKG-INFO
	distutils-r1_src_install

	insinto /etc
	insopts -m0640
	newins denyhosts.cfg-dist denyhosts.conf

	dodir /etc/logrotate.d
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	newinitd "${FILESDIR}"/denyhosts.init-r2 denyhosts
	systemd_dounit "${FILESDIR}"/${PN}.service

	# build system installs docs that we installed above
	rm -f "${D}"/usr/share/denyhosts/*.txt

	keepdir /var/lib/denyhosts
}

pkg_postinst() {
	if [[ ! -f "${ROOT}etc/hosts.deny" ]]; then
		touch "${ROOT}etc/hosts.deny"
	fi

	readme.gentoo_print_elog
}
