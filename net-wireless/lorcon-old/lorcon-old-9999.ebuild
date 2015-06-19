# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/lorcon-old/lorcon-old-9999.ebuild,v 1.2 2013/04/19 13:51:43 zerochaos Exp $

EAPI=5

inherit toolchain-funcs eutils subversion

DESCRIPTION="A generic library for injecting 802.11 frames"
HOMEPAGE="http://802.11ninja.net/lorcon"
SRC_URI=""
ESVN_REPO_URI="http://802.11ninja.net/svn/lorcon/branch/lorcon-old"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/libnl
	net-libs/libpcap"
RDEPEND="${DEPEND}"

src_install() {
	DESTDIR="${D}" emake install
	# rename manpage to avoid conflict with lorcon
	mv "${D}"/usr/share/man/man3/lorcon.3 "${D}"/usr/share/man/man3/lorcon-old.3
}
