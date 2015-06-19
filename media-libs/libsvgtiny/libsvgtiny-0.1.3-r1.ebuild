# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsvgtiny/libsvgtiny-0.1.3-r1.ebuild,v 1.1 2015/06/09 22:05:05 xmw Exp $

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.3
inherit netsurf

DESCRIPTION="framebuffer abstraction library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libsvgtiny/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k-mint"
IUSE=""

RDEPEND=">=net-libs/libdom-0.1.2-r1[xml,static-libs?,${MULTILIB_USEDEP}]
	>=dev-libs/libwapcaplet-0.2.2-r1[static-libs?,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	dev-util/gperf
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-glibc2.20.patch
	"${FILESDIR}"/${P}-parallel-build.patch )
