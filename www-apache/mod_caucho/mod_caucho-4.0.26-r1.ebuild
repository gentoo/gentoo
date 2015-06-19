# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_caucho/mod_caucho-4.0.26-r1.ebuild,v 1.1 2015/05/09 08:16:46 pacho Exp $

EAPI=5
inherit eutils apache-module autotools

DESCRIPTION="mod_caucho connects Resin and Apache2"
HOMEPAGE="http://www.caucho.com/"
SRC_URI="http://www.caucho.com/download/resin-${PV}-src.zip
	mirror://gentoo/resin-gentoo-patches-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="app-arch/unzip
	~virtual/jre-1.6.0"
RDEPEND="~virtual/jre-1.6.0"

S="${WORKDIR}/resin-${PV}"

# See apache-module.eclass for more information.
APACHE2_MOD_CONF="88_${PN}"
APACHE2_MOD_DEFINE="CAUCHO"
APACHE2_MOD_FILE="${S}/modules/c/src/apache2/.libs/${PN}.so"

need_apache2_4

src_prepare() {
	# Apache 2.4
	sed -i \
		-e 's/remote_ip/client_ip/g' \
		-e 's/remote_addr/client_addr/g' \
		modules/c/src/apache2/mod_caucho.c || die

	for i in "${WORKDIR}"/${PV}/mod_caucho-*; do
		epatch "${i}"
	done

	mkdir m4
	eautoreconf
	chmod 755 ./configure
}

src_configure() {
	econf --with-apxs=${APXS} --with-java-home=/usr
}

src_compile() {
	emake -C "${S}/modules/c/src/apache2/"
}
