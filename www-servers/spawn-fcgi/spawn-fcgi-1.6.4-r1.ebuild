# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A FCGI spawner for lighttpd and cherokee and other webservers"
HOMEPAGE="https://redmine.lighttpd.net/projects/spawn-fcgi"
SRC_URI="https://www.lighttpd.net/download/${P}.tar.xz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ppc ppc64 sparc x86"
IUSE="ipv6"

DEPEND=""
RDEPEND="
	!<=www-servers/lighttpd-1.4.20
	!<=www-servers/cherokee-0.98.1
"

src_configure() {
	econf $(use_enable ipv6)
}

src_install() {
	default

	newconfd "${FILESDIR}"/spawn-fcgi.confd spawn-fcgi
	newinitd "${FILESDIR}"/spawn-fcgi.initd-r3 spawn-fcgi

	docinto examples
	dodoc doc/run-generic doc/run-php doc/run-rails
}
