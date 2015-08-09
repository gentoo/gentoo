# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils multilib autotools

KEYWORDS="amd64 ppc ~sparc x86"

DESCRIPTION="NSS MySQL Library"
HOMEPAGE="http://libnss-mysql.sourceforge.net/"
SRC_URI="http://libnss-mysql.sourceforge.net/snapshot/${PN}-${PV/1.5_p/}.tgz"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

DEPEND="virtual/mysql"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-automagic-debug.diff
	eautoconf
}

src_configure() {
	# Usually, authentication libraries don't belong into usr.
	# But here, it's required that the lib is in the same dir
	# as libmysql, because else failures may occur on boot if
	# udev tries to access a user / group that doesn't exist
	# on the system before /usr is mounted.
	econf --libdir="/usr/$(get_libdir)" \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die

	find "${D}" -name '*.la' -delete

	newdoc sample/README README.sample
	dodoc AUTHORS DEBUGGING FAQ INSTALL NEWS README THANKS \
		TODO UPGRADING ChangeLog

	for subdir in sample/{linux,freebsd,complex,minimal} ; do
		docinto "${subdir}"
		dodoc "${subdir}/"{*.sql,*.cfg}
	done
}
