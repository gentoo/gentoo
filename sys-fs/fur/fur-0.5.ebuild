# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="A RAPI (SynCE) based FUSE module"
HOMEPAGE="https://sourceforge.net/projects/synce/"
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
