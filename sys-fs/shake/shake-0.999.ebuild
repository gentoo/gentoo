# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/shake/shake-0.999.ebuild,v 1.7 2014/05/13 06:53:13 voyageur Exp $

EAPI=5
inherit cmake-utils eutils

DESCRIPTION="defragmenter that runs in userspace while the system is used"
HOMEPAGE="http://vleu.net/shake/"
SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="sys-apps/attr"
DEPEND="${RDEPEND}
	sys-apps/help2man"

S=${WORKDIR}/${PN}-fs-${PV}

PATCHES=(
	"${FILESDIR}"/${P}-fix_stat_include.patch
	"${FILESDIR}"/${P}-uclibc.patch
	)
