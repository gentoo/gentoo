# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/srm/srm-1.2.11-r2.ebuild,v 1.7 2014/08/10 18:10:02 slyfox Exp $

EAPI="4"

inherit autotools eutils

DESCRIPTION="A command-line compatible rm which destroys file contents before unlinking"
HOMEPAGE="http://sourceforge.net/projects/srm/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="debug"

DEPEND="!app-misc/secure-delete
		sys-kernel/linux-headers
"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.2.11-cflags.patch"
	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

pkg_postinst() {
	ewarn "Please note that srm will not work as expected with any journaled file"
	ewarn "system (e.g., reiserfs, ext3)."
	ewarn "See: ${EROOT%/}/usr/share/doc/${PF}/README"
}
