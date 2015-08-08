# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="iptables firewall configuration system"
HOMEPAGE="http://muse.linuxmafia.org/gshield.html"
SRC_URI="ftp://muse.linuxmafia.org/pub/gShield/v2/gShield-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND="
	net-dns/bind-tools
	net-firewall/iptables
	virtual/logger
"

S=${WORKDIR}/gShield-${PV}

src_install() {
	# install config files
	dodir /etc/gshield
	cp -pPR * "${D}"/etc/gshield || die
	ln -s gshield "${D}"/etc/firewall || die

	# get rid of docs from config
	rm -r "${D}"/etc/gshield/{Changelog,INSTALL,LICENSE,docs} || die

	# move non-config stuff out of config, but make symlinks
	dodir /usr/share/gshield/routables
	for q in gShield-version gShield.rc tools sourced routables/routable.rules
	do
		mv "${D}"/etc/gshield/$q "${D}"/usr/share/gshield/ || die
		ln -s /usr/share/gshield/$q "${D}"/etc/gshield/$q || die
	done
	chmod -R u+rwX "${D}"/etc/gshield || die

	# install init script
	newinitd "${FILESDIR}"/gshield.init gshield
	chmod -R u+rwx "${D}"/etc/init.d/gshield || die

	# install docs
	dodoc Changelog docs/*
}
