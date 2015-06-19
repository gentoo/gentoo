# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/hdrecover/hdrecover-0.4.ebuild,v 1.2 2013/01/07 02:34:15 jdhore Exp $

EAPI=5

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="Attempts to recover a hard disk that has bad blocks on it"
HOMEPAGE="http://hdrecover.sourceforge.net/"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

src_configure() {
	# we don't want the command to be visible to non-root users.
	econf --bindir=/usr/sbin
}
