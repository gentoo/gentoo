# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/fakeroot-ng/fakeroot-ng-0.17.ebuild,v 1.3 2012/07/03 10:07:17 ssuominen Exp $

EAPI=4
inherit eutils

DESCRIPTION="A utility to run commands with fake root privileges"
HOMEPAGE="http://sourceforge.net/projects/fakerootng/"
SRC_URI="mirror://sourceforge/${PN//-/}/${PF}.tar.gz
	http://dev.gentoo.org/~ssuominen/${P}-gcc47.patch.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	epatch "${WORKDIR}"/${P}-gcc47.patch
}
