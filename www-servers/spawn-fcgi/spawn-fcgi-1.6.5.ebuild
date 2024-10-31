# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A FCGI spawner for lighttpd and cherokee and other webservers"
HOMEPAGE="https://redmine.lighttpd.net/projects/spawn-fcgi/wiki"
SRC_URI="https://download.lighttpd.net/spawn-fcgi/releases-1.6.x/${P}.tar.xz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ppc ppc64 sparc x86"

src_install() {
	default

	newconfd "${FILESDIR}"/spawn-fcgi.confd spawn-fcgi
	newinitd "${FILESDIR}"/spawn-fcgi.initd-r3 spawn-fcgi

	docinto examples
	dodoc doc/run-generic doc/run-php doc/run-rails
}
