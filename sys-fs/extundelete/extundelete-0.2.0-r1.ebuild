# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/extundelete/extundelete-0.2.0-r1.ebuild,v 1.3 2012/06/20 08:20:23 jdhore Exp $

EAPI=4
inherit eutils

_E2FS=1.42

DESCRIPTION="A utility to undelete files from an ext3 or ext4 partition"
HOMEPAGE="http://extundelete.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=sys-fs/e2fsprogs-${_E2FS}
	>=sys-libs/e2fsprogs-libs-${_E2FS}"
DEPEND="${RDEPEND}"

DOCS="README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
}
