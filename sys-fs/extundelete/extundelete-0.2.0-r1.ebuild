# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
