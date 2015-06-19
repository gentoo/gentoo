# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pretrace/pretrace-0.4.ebuild,v 1.6 2009/01/14 04:32:20 vapier Exp $

inherit eutils multilib

DESCRIPTION="start dynamically linked applications under debugging environment"
HOMEPAGE="http://dev.inversepath.com/trac/pretrace"
SRC_URI="http://dev.inversepath.com/pretrace/libpretrace-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S="${WORKDIR}/lib${P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}--as-needed.diff
	epatch "${FILESDIR}"/${P}-build.patch #227923
}

src_install() {
	dodir /usr/bin /usr/share/man/man{3,8}
	einstall LIBDIR="${D}/usr/$(get_libdir)" PREFIX="${D}/usr" || die
	prepalldocs
}

pkg_postinst() {
	elog "remember to execute ptgenmap after modifying pretrace.conf"
}
