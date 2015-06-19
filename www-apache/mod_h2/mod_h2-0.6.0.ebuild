# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_h2/mod_h2-0.6.0.ebuild,v 1.1 2015/05/24 13:55:51 vapier Exp $

EAPI="5"

inherit apache-module

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/icing/mod_h2.git"
	inherit git-2
else
	SRC_URI="https://github.com/icing/mod_h2/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="HTTP/2 module for Apache"
HOMEPAGE="https://github.com/icing/mod_h2"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="ssl"

RDEPEND="=net-libs/nghttp2-0.7*"
DEPEND="${RDEPEND}"

need_apache2_4

src_configure() {
	econf \
		--docdir='$(datarootdir)'/doc/${PF} \
		--disable-werror \
		--disable-sandbox
}

src_compile() {
	default
}

src_install() {
	default

	APACHE2_MOD_DEFINE="HTTP2"
	insinto "${APACHE_MODULES_CONFDIR}"
	newins "${FILESDIR}/mod_h2.conf" "75_mod_h2.conf"
}
