# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit apache-module depend.apache

DESCRIPTION="mod_dnssd is an Apache module which adds Zeroconf support via DNS-SD using Avahi"
HOMEPAGE="https://0pointer.de/lennart/projects/mod_dnssd/"
SRC_URI="https://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="net-dns/avahi[dbus]"
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="80_${PN}"
APACHE2_MOD_DEFINE="DNSSD"

need_apache2

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
	"${FILESDIR}/${P}-httpd24.patch"
)

# Work around Bug #616612
pkg_setup() {
	_init_apache2
	_init_apache2_late
}

src_configure() {
	econf --with-apxs=${APXS} --disable-lynx
}

# Do not use inherited src_compile since it doesn't do what we want
src_compile() {
	emake
}
