# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_DOC_DIRS="docbook"
KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE frontend for Linux LVM2 and GNU parted"
HOMEPAGE="http://kvpm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	sys-apps/util-linux
	>=sys-block/parted-2.3
	>=sys-fs/lvm2-2.02.98
"
DEPEND="${RDEPEND}"
