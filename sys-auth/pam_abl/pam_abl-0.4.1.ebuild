# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MY_PN="${PN/_/-}"
MY_P="${MY_PN}-${PV}"

inherit flag-o-matic pam

DESCRIPTION="PAM module for blacklisting of hosts and users on repeated failed authentication attempts"
HOMEPAGE="http://pam-abl.deksai.com/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=sys-libs/pam-0.78-r2
	>=sys-libs/db-4.2.52_p2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--enable-shared \
		--disable-static \
		--disable-dependency-tracking \
		--enable-fast-install \
		--docdir=/usr/share/doc/${PF} \
		--with-pam-dir=$(getpam_mod_dir) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dopamsecurity . conf/pam_abl.conf

	keepdir /var/db/abl
}

pkg_postinst() {
	elog "See /usr/share/doc/${PF}/ for configuration info and set up "
	elog "/etc/security/pam_abl.conf as needed."
}
