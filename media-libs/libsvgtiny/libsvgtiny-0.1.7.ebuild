# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NETSURF_BUILDSYSTEM=buildsystem-1.7
inherit netsurf

DESCRIPTION="framebuffer abstraction library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libsvgtiny/"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc ~m68k-mint"
IUSE=""

RDEPEND=">=net-libs/libdom-0.1.2-r1[xml,static-libs?,${MULTILIB_USEDEP}]
	>=dev-libs/libwapcaplet-0.2.2-r1[static-libs?,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	dev-util/gperf
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-0.1.3-parallel-build.patch )

src_prepare() {
	# working around broken netsurf eclass
	default
	multilib_copy_sources
}
