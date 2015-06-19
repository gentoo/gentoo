# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/fur/fur-0.5.ebuild,v 1.1 2012/06/17 11:00:23 ssuominen Exp $

EAPI=4

DESCRIPTION="A RAPI (SynCE) based FUSE module"
HOMEPAGE="http://sourceforge.net/projects/synce/"
SRC_URI="mirror://sourceforge/synce/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="void-chmod"

RDEPEND="app-pda/synce-core
	sys-fs/fuse"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local myconf
	use void-chmod && myconf="--enable-void-chmod"
	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	dosym Fur /usr/bin/fur

	dodoc Changelog README.txt
	dohtml docs/*.html
}
