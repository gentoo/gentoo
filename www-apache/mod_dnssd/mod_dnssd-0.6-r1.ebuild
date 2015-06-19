# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_dnssd/mod_dnssd-0.6-r1.ebuild,v 1.3 2015/05/13 09:33:39 ago Exp $

EAPI=5
inherit apache-module eutils

DESCRIPTION="mod_dnssd is an Apache module which adds Zeroconf support via DNS-SD using Avahi"
HOMEPAGE="http://0pointer.de/lennart/projects/mod_dnssd/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND="net-dns/avahi[dbus]"
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="80_${PN}"
APACHE2_MOD_DEFINE="DNSSD"

need_apache2

src_prepare() {
	# Respect LDFLAGS and use LIBS properly.
	epatch "${FILESDIR}/${P}-ldflags.patch"

	# Fedora patch for apache 2.4
	epatch "${FILESDIR}/${P}-httpd24.patch"
}

src_configure() {
	econf --with-apxs=${APXS} --disable-lynx
}

# Do not use inherited src_compile since it doesn't do what we want
src_compile() {
	emake
}
