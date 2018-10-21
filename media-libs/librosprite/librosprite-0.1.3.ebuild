# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NETSURF_BUILDSYSTEM=buildsystem-1.7
inherit netsurf

DESCRIPTION="framebuffer abstraction library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/librosprite/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~m68k-mint"
IUSE=""

PATCHES=( "${FILESDIR}"/${PN}-0.1.2-Werror.patch )

src_prepare() {
	# working around broken netsurf eclass
	default
	multilib_copy_sources
}
