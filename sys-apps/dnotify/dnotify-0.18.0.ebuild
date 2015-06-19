# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dnotify/dnotify-0.18.0.ebuild,v 1.10 2010/09/10 05:06:06 ssuominen Exp $

EAPI=2
inherit eutils

DESCRIPTION="Execute a command when the contents of a directory change"
HOMEPAGE="http://directory.fsf.org/project/dnotify/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc -sparc x86"
IUSE="nls"

RDEPEND=""
DEPEND="nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-nls.patch \
		"${FILESDIR}"/${P}-glibc-212.patch
}

src_configure() {
	econf \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS TODO NEWS README
}
