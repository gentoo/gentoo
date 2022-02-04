# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit apache-module depend.apache

DESCRIPTION="Binary-compatible alternative to mod_fastcgi with better process management"
HOMEPAGE="https://httpd.apache.org/mod_fcgid/"
SRC_URI="mirror://apache/httpd/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

APACHE2_MOD_CONF="2.2/20_${PN}"
APACHE2_MOD_DEFINE="FCGID"

DOCFILES="CHANGES-FCGID README-FCGID STATUS-FCGID"

need_apache2

# Work around Bug #616612
pkg_setup() {
	_init_apache2
	_init_apache2_late
}

src_configure() {
	./configure.apxs || die "apxs configure failed"
}

src_compile() {
	emake
	ln -sf modules/fcgid/.libs .libs || die "symlink creation failed"
}
