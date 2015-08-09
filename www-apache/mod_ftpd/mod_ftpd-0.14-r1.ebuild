# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit apache-module

DESCRIPTION="Apache2 module which provides an FTP server"
HOMEPAGE="http://www.outoforder.cc/projects/apache/mod_ftpd/"
SRC_URI="http://www.outoforder.cc/downloads/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dbi gdbm"

DEPEND="dbi? ( dev-db/libdbi )
		gdbm? ( sys-libs/gdbm )"
RDEPEND="${DEPEND}"

APACHE2_EXECFILES="providers/*/.libs/*.so"
APACHE2_MOD_CONF="0.14-r1/45_${PN}"
APACHE2_MOD_DEFINE="FTPD"

DOCFILES="docs/manual.html AUTHORS ChangeLog NOTICE README TODO"

need_apache2_2

src_prepare() {
	sed -i -e 's/-Wc,-Werror//' Makefile.in providers/*/Makefile.in
}

src_configure() {
	local providers="default fail"

	use dbi && providers="dbi ${providers}"
	use gdbm && providers="dbm ${providers}"

	econf \
		--with-apxs=${APXS} \
		--enable-providers="${providers}" \
		|| die "econf failed"
	}

src_compile() {
	emake || die "emake failed"
}
