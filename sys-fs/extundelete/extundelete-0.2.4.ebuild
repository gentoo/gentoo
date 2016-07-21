# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A utility to undelete files from an ext3 or ext4 partition"
HOMEPAGE="http://extundelete.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="amd64 x86"
IUSE=""

E2FSPROGS=1.42.6
RDEPEND=">=sys-fs/e2fsprogs-${E2FSPROGS}
	>=sys-libs/e2fsprogs-libs-${E2FSPROGS}"
DEPEND=${RDEPEND}

DOCS=README
