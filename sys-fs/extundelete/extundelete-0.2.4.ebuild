# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A utility to undelete files from an ext3 or ext4 partition"
HOMEPAGE="https://extundelete.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="amd64 ~arm ~sparc x86"

RDEPEND="sys-fs/e2fsprogs
	sys-libs/e2fsprogs-libs"

DEPEND=${RDEPEND}

DOCS=README

PATCHES=( "${FILESDIR}/${P}-e2fsprogs.patch" )
